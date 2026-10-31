"""Turns generated pictures (see assets/prompts/IMAGE_PROMPTS.md) into the game's files.

    python tools/prepare_art.py KIND SOURCE TARGET [options]
    python tools/prepare_art.py erase FIXES ID

KIND:
  cover W H [ZOOM]   fill W x H: crop the middle to that shape (ZOOM > 1 crops tighter), resize. For
                     backgrounds and game cards. Saved as given (.jpg for opaque pictures).
  squash W H         resize to exactly W x H (for maps whose painted border must stay whole; only for
                     pictures already close to that shape).
  medallion N        a round emblem on a white background: the circle cut out with a clean round edge,
                     N x N, transparent PNG.
  cutout W H [holes] a character or object on a white background: the white around it made transparent
                     (only white reached from the edges, so white inside the picture stays), cropped,
                     centred in W x H with a small margin, transparent PNG. With "holes", white shut in
                     by the picture goes too (between the cords of a hanging basket, inside a ring):
                     only for pictures that have no white of their own.
  figure W H SCALE CX [CROP_Y|-] [FADE|-] [TOP]
                     a character on a white background, for a set of poses that must match: cut out as
                     for "cutout" (but the white is only followed in from the top and the sides, so a
                     figure that runs into the bottom edge keeps its white clothes), optionally cut off
                     below CROP_Y (e.g. a cloud it stands on), scaled by SCALE (chosen per pose so the
                     heads are the same size), the source column CX (the middle of the body) placed at
                     45% across W x H, and the figure standing on the bottom edge. FADE "x0,y0,x1,y1"
                     (source pixels): a box where pale, nearly white pixels fade out, for a soft glow
                     that is not quite white (e.g. around a thunderbolt in a hand). TOP: instead of
                     standing on the bottom edge, the top of the figure is TOP pixels below the top
                     edge and what does not fit is cut off at the bottom (for half figures cut off at
                     the bottom of their picture, whose heads must line up). Transparent PNG.
  erase FIXES ID     paints over what a generator added that the game does not want (names written on a
                     map, its own marker discs): the boxes listed under ID in the JSON file FIXES, as
                     fractions of the picture (x0, y0, x1, y1). In a "text" box only the lettering is
                     filled (what stands out from its surroundings), in a "disc" box everything; the
                     hole is filled from the paper or sea around it. the file named in FIXES is changed in place.

The white background is anything brighter than WHITE in every channel; the edge of the cut-out is
softened over a pixel or two so it shows no white fringe.
"""
import sys

import numpy as np
from PIL import Image
from scipy import ndimage

WHITE = 236  # brighter than this in every channel counts as the white background
MARGIN = 0.04  # room around a cut-out, as a share of the target size


def save(img, target):
    if target.lower().endswith((".jpg", ".jpeg")):
        img.convert("RGB").save(target, quality=90, optimize=True)
    else:
        img.save(target, optimize=True)
    print("%s  %dx%d" % (target, img.width, img.height))


def cover(img, w, h, zoom=1.0):
    src_ratio = img.width / img.height
    ratio = w / h
    cw, ch = (img.height * ratio, img.height) if src_ratio > ratio else (img.width, img.width / ratio)
    cw, ch = cw / zoom, ch / zoom
    x0, y0 = (img.width - cw) / 2.0, (img.height - ch) / 2.0
    return img.crop((round(x0), round(y0), round(x0 + cw), round(y0 + ch))).resize((w, h), Image.LANCZOS)


def background_mask(rgb, bottom=True, holes=False):
    """True where the picture is the white background joined to its edges (the bottom edge only if
    `bottom`); with `holes`, all of the white."""
    white = (rgb > WHITE).all(axis=2)
    if holes:
        return white
    labels, _ = ndimage.label(white)
    edges = [labels[0], labels[:, 0], labels[:, -1]] + ([labels[-1]] if bottom else [])
    edge = np.unique(np.concatenate(edges))
    return np.isin(labels, edge[edge > 0])


def cutout_rgba(img, bottom=True, holes=False):
    rgb = np.asarray(img.convert("RGB")).astype(np.float32)
    bg = background_mask(rgb.astype(np.uint8), bottom, holes)
    # Soft edge: near the background, the brighter a pixel the more see-through, and its colour
    # with the white taken out, so no light fringe remains.
    near = ndimage.binary_dilation(bg, iterations=2) & ~bg
    alpha = np.where(bg, 0.0, 1.0)
    lightness = rgb.min(axis=2)
    soft = np.clip((255.0 - lightness) / (255.0 - 170.0), 0.0, 1.0)
    alpha = np.where(near, np.minimum(alpha, soft), alpha)
    alpha = ndimage.gaussian_filter(alpha, 0.6) * (~bg) + 0.0
    a = np.clip(alpha, 0.0, 1.0)[..., None]
    colour = np.where(a > 0.02, (rgb - (1.0 - a) * 255.0) / np.maximum(a, 0.02), rgb)
    out = np.concatenate([np.clip(colour, 0, 255), a * 255.0], axis=2).astype(np.uint8)
    return Image.fromarray(out, "RGBA")


def fit(rgba, w, h):
    box = rgba.getchannel("A").point(lambda v: 255 if v > 8 else 0).getbbox()
    part = rgba.crop(box)
    room_w, room_h = w * (1 - 2 * MARGIN), h * (1 - 2 * MARGIN)
    scale = min(room_w / part.width, room_h / part.height)
    part = part.resize((max(1, round(part.width * scale)), max(1, round(part.height * scale))), Image.LANCZOS)
    out = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    out.alpha_composite(part, ((w - part.width) // 2, (h - part.height) // 2))
    return out


def fade_pale(rgba, box):
    """In `box`, pixels that are pale (all channels high) become see-through, the paler the more."""
    a = np.asarray(rgba).astype(np.float32)
    x0, y0, x1, y1 = box
    part = a[y0:y1, x0:x1]
    keep = np.clip((242.0 - part[..., :3].min(axis=2)) / 40.0, 0.0, 1.0)
    part[..., 3] *= keep
    return Image.fromarray(a.astype(np.uint8), "RGBA")


def figure(img, w, h, scale, cx, crop_y=None, fade=None, top=None):
    if crop_y is not None:
        img = img.crop((0, 0, img.width, int(crop_y)))
    rgba = cutout_rgba(img, bottom=False)
    if fade is not None:
        rgba = fade_pale(rgba, fade)
    box = rgba.getchannel("A").point(lambda v: 255 if v > 8 else 0).getbbox()
    part = rgba.crop(box)
    part = part.resize((max(1, round(part.width * scale)), max(1, round(part.height * scale))), Image.LANCZOS)
    out = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    x = round(w * 0.45 - (cx - box[0]) * scale)
    y = h - part.height if top is None else int(top)
    out.paste(part, (x, y), part)  # (pasted: it may stick out of the canvas at a side or the bottom)
    return out


def medallion(img, n):
    rgb = np.asarray(img.convert("RGB"))
    bg = background_mask(rgb)
    ys, xs = np.nonzero(~bg)
    # the circle: its centre and radius from the area that is not background
    cx, cy = (xs.min() + xs.max()) / 2.0, (ys.min() + ys.max()) / 2.0
    r = min(xs.max() - xs.min(), ys.max() - ys.min()) / 2.0 - 1.0
    side = int(np.ceil(2 * r))
    x0, y0 = int(round(cx - r)), int(round(cy - r))
    part = img.convert("RGBA").crop((x0, y0, x0 + side, y0 + side)).resize((n, n), Image.LANCZOS)
    big = 4 * n  # an antialiased round mask
    yy, xx = np.mgrid[0:big, 0:big]
    inside = ((xx + 0.5 - big / 2.0) ** 2 + (yy + 0.5 - big / 2.0) ** 2) <= (big / 2.0 - 2) ** 2
    mask = Image.fromarray((inside * 255).astype(np.uint8)).resize((n, n), Image.LANCZOS)
    part.putalpha(mask)
    return part


def erase(img, boxes):
    rgb = np.asarray(img.convert("RGB")).astype(np.float32)
    h, w = rgb.shape[:2]
    lum = rgb.mean(axis=2)
    surround = ndimage.median_filter(lum, size=max(15, w // 90))
    mask = np.zeros((h, w), bool)
    discs = np.zeros((h, w), bool)
    yy, xx = np.mgrid[0:h, 0:w]
    for box in boxes:
        x0, y0, x1, y1 = (int(round(v * (w if i % 2 == 0 else h))) for i, v in enumerate(box["box"]))
        if box["kind"] == "disc":  # (a little wider than the box: its soft shadow too)
            cx, cy, rx, ry = (x0 + x1) / 2.0, (y0 + y1) / 2.0, (x1 - x0) * 0.68, (y1 - y0) * 0.68
            discs |= ((xx - cx) / rx) ** 2 + ((yy - cy) / ry) ** 2 <= 1.0
        else:
            mask[y0:y1, x0:x1] |= np.abs(lum[y0:y1, x0:x1] - surround[y0:y1, x0:x1]) > 28
    mask = ndimage.binary_dilation(mask, iterations=max(2, w // 640)) | discs
    # Fill from the outside in: each round, the holes' edge takes the average of its known neighbours.
    known = ~mask
    out = rgb.copy()
    rng = np.random.default_rng(7)
    while not known.all():
        weights = ndimage.uniform_filter(known.astype(np.float32), 5)
        sums = np.stack([ndimage.uniform_filter(out[..., c] * known, 5) for c in range(3)], axis=2)
        edge = ~known & (weights > 0.05)
        out[edge] = sums[edge] / weights[edge][:, None] + rng.normal(0.0, 2.5, (int(edge.sum()), 3))
        known |= edge
    if discs.any():  # a disc's fill is wide: smooth away the streaks of filling inwards, keep a little grain
        smooth = np.stack([ndimage.gaussian_filter(out[..., c], w / 300.0) for c in range(3)], axis=2)
        soft = ndimage.gaussian_filter(discs.astype(np.float32), 3.0)[..., None]
        out = smooth * soft + out * (1.0 - soft) + rng.normal(0.0, 2.0, out.shape) * soft
    return Image.fromarray(np.clip(out, 0, 255).astype(np.uint8))


def main():
    kind = sys.argv[1]
    if kind == "erase":
        import json
        fixes, fix_id = sys.argv[2], sys.argv[3]
        entry = json.load(open(fixes, encoding="utf-8"))[fix_id]
        save(erase(Image.open(entry["file"]), entry["boxes"]), entry["file"])
        return
    src, dst = sys.argv[2], sys.argv[3]
    args = sys.argv[4:]
    img = Image.open(src)
    if kind == "cover":
        save(cover(img.convert("RGB"), int(args[0]), int(args[1]), float(args[2]) if len(args) > 2 else 1.0), dst)
    elif kind == "squash":
        save(img.convert("RGB").resize((int(args[0]), int(args[1])), Image.LANCZOS), dst)
    elif kind == "medallion":
        save(medallion(img, int(args[0])), dst)
    elif kind == "figure":
        crop = float(args[4]) if len(args) > 4 and args[4] != "-" else None
        fade = tuple(int(v) for v in args[5].split(",")) if len(args) > 5 and args[5] != "-" else None
        top = float(args[6]) if len(args) > 6 else None
        save(figure(img, int(args[0]), int(args[1]), float(args[2]), float(args[3]), crop, fade, top), dst)
    elif kind == "cutout":
        holes = len(args) > 2 and args[2] == "holes"
        save(fit(cutout_rgba(img, holes=holes), int(args[0]), int(args[1])), dst)
    else:
        sys.exit("unknown kind " + kind)


if __name__ == "__main__":
    main()
