# iTerm2 - theme "Deep Harbor"

Theme toi, nen navy + chu kem, dung cho Claude Code. Bang mau lay tu palette
ca nhan; moi mau chu deu dat >= 4.5:1 tuong phan voi nen (tru do thuong
`#e13a41` 3.57:1, chi dung cho token ngan nhu dau `-` trong diff).

## File

| File | La gi |
|---|---|
| `DynamicProfiles/deep-harbor.json` | Profile day du: mau + font + gian dong + terminal. Self-contained, khong ke thua profile nao tren may dich. |
| `Deep Harbor.itermcolors` | Chi rieng bang mau. Dung khi muon giu profile san co, chi doi mau. |
| `apply.sh` | Cai font, dat lam profile mac dinh. |
| `gen_theme.py` | Sinh lai 2 file tren. Sua mau o day roi chay `python3 gen_theme.py`. |
| `profile.itermexport` | Ban export cu (2025-04), gzip nhi phan, khong diff duoc. Giu lai de phong. |

## Cai tren may moi

```bash
cd ~/Dropbox/Projects/dotfiles && ./install     # dotbot tao symlink
bash iterm2/apply.sh                            # font + set default profile
```

Dynamic profile khong can import: iTerm2 quet thu muc
`~/Library/Application Support/iTerm2/DynamicProfiles/` luc khoi dong va khi
file doi, roi tu them profile vao danh sach.

Vi day la symlink toi Dropbox, khi Dropbox dong bo mot thay doi tu may khac,
iTerm co the khong bat duoc su kien -> khoi dong lai iTerm la an.

## Bat buoc: theme cua Claude Code

```
/config  ->  Theme  ->  Dark mode (ANSI colors only)
```

Claude Code mac dinh dung theme `dark`, phat mau RGB tuyet doi va **bo qua hoan
toan** palette cua terminal. Chi o che do `dark-ansi` no moi map UI ve 16 slot
ANSI. Dau hieu da dung: inline code chuyen tu tim periwinkle sang xanh.

## Bang mau

Nen `#182635` - chu `#eee6d9` (12.4:1)

| | Thuong | Sang |
|---|---|---|
| black | `#2b333b` | `#8795a0` <- chu mo/phu, 5.0:1 |
| red | `#e13a41` | `#e67c73` |
| green | `#4daa83` | `#6fcfa4` |
| yellow | `#f49d00` | `#fbd874` |
| blue | `#0098b9` | `#57bedd` |
| magenta | `#fa8155` | `#ffa98a` |
| cyan | `#21a691` | `#4bd1b5` |
| white | `#c2c2c2` | `#ffffff` |

Bold `#ffad36` - cursor `#ffad36` - selection `#00526b` - badge `#cd9057`

## Cac quyet dinh dang nho

- `Normal Font = JetBrainsMonoNFM-Regular` chu **khong** `-Bold`. Neu chu nen
  da dam san thi `**bold**` cua Claude Code khong con nac nao de dam hon, toan
  man hinh trong nhu nhau.
- `Use Bright Bold = true`: bat buoc, neu tat thi iTerm bo qua `Bold Color`.
- `Use Separate Colors for Light and Dark Mode = false`: bat buoc. De `true`
  thi may dang o giao dien Light se khong ra dung mau.
- `Thin Strokes = 0` (Never): net chu day hon tren nen toi.
- `Vertical Spacing = 1.15`: output Claude Code rat day, gian dong an tien nhat.
- iTerm2 **khong co** o mau cho italic. Chu trong blockquote se luon cung mau
  voi body, chi khac o net nghieng. Khong sua duoc o tang terminal.
- O `Link Color` chi ap cho URL ma chinh iTerm do de Cmd+click, khong ap cho
  text mau do chuong trinh in ra.
