#!/usr/bin/env python3
"""Sinh theme + profile iTerm2 'Deep Harbor' vao dotfiles (portable, self-contained)."""
import json, os, plistlib

DOTFILES = os.path.expanduser("~/code/dotfiles/iterm2")

BG = "#182635"
COLORS = {
    "Ansi 0 Color":  "#2b333b",   "Ansi 8 Color":  "#8795a0",
    "Ansi 1 Color":  "#e13a41",   "Ansi 9 Color":  "#e67c73",
    "Ansi 2 Color":  "#4daa83",   "Ansi 10 Color": "#6fcfa4",
    "Ansi 3 Color":  "#f49d00",   "Ansi 11 Color": "#fbd874",
    "Ansi 4 Color":  "#0098b9",   "Ansi 12 Color": "#57bedd",
    "Ansi 5 Color":  "#fa8155",   "Ansi 13 Color": "#ffa98a",
    "Ansi 6 Color":  "#21a691",   "Ansi 14 Color": "#4bd1b5",
    "Ansi 7 Color":  "#c2c2c2",   "Ansi 15 Color": "#ffffff",
    "Background Color":    BG,
    "Foreground Color":    "#eee6d9",
    "Bold Color":          "#ffad36",
    "Cursor Color":        "#ffad36",
    "Cursor Text Color":   "#182635",
    "Selection Color":     "#00526b",
    "Selected Text Color": "#eee6d9",
    "Link Color":          "#57bedd",
    "Underline Color":     "#57bedd",
    "Badge Color":         "#cd9057",
    "Cursor Guide Color":  "#27403e",
    "Tab Color":           "#182635",
}
ALPHA = {"Badge Color": 0.5, "Cursor Guide Color": 0.25}


def rgb(h):
    h = h.lstrip("#")
    return tuple(int(h[i:i+2], 16) / 255.0 for i in (0, 2, 4))


def comp(h, alpha=1.0):
    r, g, b = rgb(h)
    return {"Alpha Component": alpha, "Blue Component": b, "Color Space": "sRGB",
            "Green Component": g, "Red Component": r}


colors = {k: comp(v, ALPHA.get(k, 1.0)) for k, v in COLORS.items()}

os.makedirs(os.path.join(DOTFILES, "DynamicProfiles"), exist_ok=True)

# 1) Preset mau thuan tuy - import vao BAT KY profile nao
with open(os.path.join(DOTFILES, "Deep Harbor.itermcolors"), "wb") as fh:
    plistlib.dump(colors, fh)

# 2) Profile day du - self-contained, khong ke thua profile nao tren may dich
profile = dict(colors)
profile.update({
    "Name": "Deep Harbor",
    "Guid": "DEEPHARBOR-2026-FIN-01",

    # --- QUAN TRONG: mot bo mau duy nhat cho ca light lan dark appearance ---
    "Use Separate Colors for Light and Dark Mode": False,

    # --- Chu ---
    "Normal Font": "JetBrainsMonoNFM-Regular 14",
    "Non Ascii Font": "JetBrainsMonoNFM-Regular 14",
    "Use Non-ASCII Font": False,
    "Vertical Spacing": 1.15,
    "Horizontal Spacing": 1.0,
    "Use Bold Font": True,
    "Use Italic Font": True,
    "Use Bright Bold": True,          # bat buoc, neu tat thi Bold Color bi bo qua
    "ASCII Anti Aliased": True,
    "Non-ASCII Anti Aliased": True,
    "ASCII Ligatures": False,
    "Thin Strokes": 0,                # 0 = Never -> net chu day hon
    "Minimum Contrast": 0,
    "Draw Powerline Glyphs": True,
    "Ambiguous Double Width": False,

    # --- Con tro ---
    "Cursor Type": 1,                 # 1 = vertical bar
    "Blinking Cursor": False,

    # --- Cua so ---
    "Columns": 120,
    "Rows": 32,
    "Window Type": 0,
    "Transparency": 0,
    "Blur": False,
    "Unlimited Scrollback": True,

    # --- Terminal ---
    "Terminal Type": "xterm-256color",
    "Character Encoding": 4,
    "Mouse Reporting": True,
    "Option Key Sends": 0,
    "Right Option Key Sends": 0,
    "Silence Bell": False,
    "Close Sessions On End": True,
    "Prompt Before Closing 2": False,
    "Sync Title": False,
    "Jobs to Ignore": ["rlogin", "ssh", "slogin", "telnet"],
    "Custom Directory": "No",
    "Custom Command": "No",
})

with open(os.path.join(DOTFILES, "DynamicProfiles", "deep-harbor.json"), "w") as fh:
    json.dump({"Profiles": [profile]}, fh, indent=2)
    fh.write("\n")

print("Da ghi vao", DOTFILES)
print("  Deep Harbor.itermcolors        (preset mau)")
print("  DynamicProfiles/deep-harbor.json (profile day du,", len(profile), "keys)")
