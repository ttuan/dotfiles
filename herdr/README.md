# herdr - terminal workspace manager cho AI agent

Quan ly workspace/tab/pane cho cac phien AI agent chay song song, co sidebar
hien trang thai tung agent (working / done / blocked / idle). Trang chu:
https://herdr.dev

## File

| File | La gi |
|---|---|
| `config.toml` | Cau hinh chinh. Symlink toi `~/.config/herdr/config.toml`. Gom keybinding kieu tmux, theme tokyo-night chinh mau, va bo cuc sidebar. |
| `herdr-workspace-3tabs.sh` | Dung bo 3 tab `code` / `agents` / `console` tai cwd dang focus. Symlink toi `~/.local/bin/herdr-workspace-3tabs`. Gan vao `prefix+t` (thay tab hien tai) va `prefix+shift+t` (workspace moi). |
| `herdr-claude-meta.sh` | Day ten phien + email account Claude + quota 5h len sidebar. Symlink toi `~/.local/bin/herdr-claude-meta`. Xem muc rieng ben duoi. |

Chi `config.toml` duoc symlink vao `~/.config/herdr/`; thu muc do con chua
socket, log va session state nen khong symlink ca thu muc.

## Cai tren may moi

```bash
cd ~/code/dotfiles && ./install     # dotbot tao ca 3 symlink
herdr --version                     # xac nhan binary da co
herdr config check                  # phai in "config: ok"
```

Binary `herdr` tu cai lay (`~/.local/bin/herdr`), khong nam trong repo nay.
Sau khi doi `config.toml` thi khong can khoi dong lai session:

```bash
herdr server reload-config          # phai tra ve status: "applied"
```

## Sidebar cho pane Claude

Khi chay nhieu account Claude song song (`~/.claude`, `~/.claude-work`,
`~/.claude-personal`, `~/.claude-alt`) thi khong nhin ra pane nao dang dung account nao, cung
khong biet account do da tieu bao nhieu quota. Khoi agent cua pane Claude vi
the co 4 hang thay vi 2:

```
|<--------- 26 cot -------->|
my-project        agents     <- workspace + ten phien (hoac ten tab)
⠐ working           claude
👤 tuantv.nhnd
📊 5h 23% (43m)
```

Mau cua hang quota doi theo nguong: xanh `< 70%`, cam `70-89%`, do `>= 90%`.

### Hang 1: ten phien thay cho ten tab

Hang 1 dung token `$convo` chu khong dung token dung san `tab`:

1. Neu phien da duoc dat ten bang **`/rename`** thi hien ten do.
2. Neu chua thi lui ve **ten tab**, tuc giong het hanh vi cu.

**Khong** dung `session_name` trong payload statusline de phan biet hai truong
hop: truong do luon co gia tri, va khi chua `/rename` thi no chinh la ten AI tu
sinh (`ai-title`, doi lien tuc theo noi dung dang lam). Chi co `/rename` moi ghi
ban ghi `{"type":"custom-title","customTitle":...}` vao transcript, nen script
doc `transcript_path` de tim. Loc bang chuoi con truoc khi parse JSON: quet het
file 950KB het khoang 2ms.

Config khong co menh de dieu kien, nen script phai tu chon roi day sang mot
token duy nhat. Keo theo hai he qua:

- Doi ten tab bang `prefix+,` chi hien ra o lan render statusline ke tiep chu
  khong tuc thi.
- Neu script hong thi hang 1 mat ten tab. Token co `ttl_ms` 6 tieng nen gia tri
  cuoi cung van con do trong luc do.

### Hoat dong the nao

```
Claude Code (pane, CLAUDE_CONFIG_DIR=~/.claude-work)
   |  moi lan render statusline
   v
~/.claude-work/statusline-command.sh
   |  da co san $account_email, $account_org, $FIVE_H, $FIVE_H_RESET
   |  + .transcript_path lay tu payload stdin
   |  khoi goi o cuoi file, chay nen (&)
   v
~/.local/bin/herdr-claude-meta
   |  doc $HERDR_PANE_ID + $HERDR_SOCKET_PATH tu env cua pane
   |  doc transcript tim custom-title; khong co thi hoi herdr ten tab
   v
unix socket -> herdr server: pane.report_metadata
   v
sidebar hang 1 (ten phien) + hang 3, 4
```

Moi pane tu khai bao metadata cua chinh no, nen khong can map thu cong "config
dir nao ung voi pane nao" - account nao chay o pane nao la tu dong dung.

Script khong tu goi API nao ca; no chi format lai cac gia tri ma statusline da
tinh san. Ngoai herdr thi no no-op im lang (thoat 0, khong in gi).

### Buoc BAT BUOC lam tay tren may moi

File `~/.claude/statusline-command.sh` **khong nam trong repo nay** (no doc
keychain entry rieng cua tung account), nen dotbot khong dung duoc. Phai them
tay khoi sau vao **cuoi file**:

```sh
# ─────────────────────────────────────────────────────────────
# Day ten phien + dinh danh account + quota 5h sang sidebar herdr (hang 1, 3,
# 4 cua khoi agent). Chay nen de khong lam cham statusline; no-op khi khong o
# trong herdr. Script: ~/code/dotfiles/herdr/herdr-claude-meta.sh
# ─────────────────────────────────────────────────────────────
if [ -x "$HOME/.local/bin/herdr-claude-meta" ]; then
  "$HOME/.local/bin/herdr-claude-meta" \
    --email "$ACTIVE_EMAIL" \
    --org "$(echo "$AUTH_STATUS" | jq -r '.orgName // empty')" \
    --five-pct "$FIVE_H" \
    --five-reset "$FIVE_H_RESET" \
    --transcript "$(echo "$input" | jq -r '.transcript_path // empty')" \
    >/dev/null 2>&1 &
fi
```

**Chi phai lam MOT lan, khong lam cho tung config dir.** Ca bon config dir
(`~/.claude`, `~/.claude-work`, `~/.claude-personal`, `~/.claude-alt`) deu chay
chung dung file nay: ba dir sau symlink `settings.json` ve
`~/.claude/settings.json`, ma `statusLine.command` trong do la duong dan tuyet
doi `~/.claude/statusline-command.sh` (dau `~` no ra `$HOME`, khong no ra config
dir). Them khoi tren vao tung dir se thanh day trung hai lan.

Van tach duoc account theo pane vi ban than statusline da da-account: no lay
`CONFIG_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"` roi tra keychain entry rieng
cua dir do, nen `$ACTIVE_EMAIL` luon dung account cua pane dang chay.

Kiem tra lai khi nghi ngo:

```bash
for d in .claude .claude-work .claude-personal .claude-alt; do
  printf '%-16s %s\n' "$d" "$(jq -r '.statusLine.command' "$HOME/$d/settings.json")"
done
grep -c herdr-claude-meta "$HOME/.claude/statusline-command.sh"   # phai > 0
```

**Ten bien khac README goc.** Statusline hien tai dat ten `ACTIVE_EMAIL` (khong
phai `account_email`) va khong tach san org - phai moc `orgName` tu
`$AUTH_STATUS`. `FIVE_H`, `FIVE_H_RESET` va payload stdin trong `$input` thi
dung nhu cu. **Neu viet lai statusline ma doi ten bien thi phai sua theo.**

### Kiem tra

```bash
herdr config check                        # config: ok
herdr server reload-config                # status: "applied"

# Day thu vao pane dang ngoi (phai chay TRONG herdr)
herdr-claude-meta --email a@b.com --five-pct 95 --five-reset ""

# Doc lai token da nam tren pane
herdr pane get "$HERDR_PANE_ID" | python3 -m json.tool | grep -A5 tokens
```

Ket qua mong doi la `{"acct": "👤 a", "quota_crit": "📊 5h 95%"}`. Doi
`--five-pct` sang `42` / `78` de thu ba muc mau.

Voi Claude Code that thi token chi xuat hien sau lan **render statusline** dau
tien cua pane do, tuc ngay khi phien co hoat dong. Pane dang nam im tu truoc
luc cai dat se chua co gi cho toi luot tuong tac ke tiep - day la binh thuong,
chi xay ra mot lan cho moi pane mo san.

### Vi sao quota phai co 3 token

Style token trong `config.toml` la **tinh** (`RawStyledSidebarToken` chi co
`token`, `fg`, `bold`, `dim`), khong doi mau theo gia tri duoc nhu
`state_icon`/`state_text` - hai token dung san do herdr gan cung mau theo state.
Cach lach: khai ba ten token cho ba muc (`$quota_ok`, `$quota_warn`,
`$quota_crit`), moi ten mot mau co dinh; moi lan script chi dien dung mot cai,
hai cai con lai gui `null` de xoa. Nhin ra y het mau dong.

Cung ly do do ma be ngang phai giu <= 26 o (`ui.sidebar_width` mac dinh 26, toi
da 36): script tu cat bot local-part cua email, chen `…` o giua.

### Xu ly su co

| Trieu chung | Nguyen nhan thuong gap |
|---|---|
| Khong hang nao hien | Chua chay `herdr server reload-config` sau khi doi `config.toml`. |
| Hien o pane nay, khong o pane kia | Pane kia chua render statusline lan nao. Go gi do vao no. |
| `herdr config check` bao `unknown sidebar token` | Sai ten token trong `rows_by_agent`, phai co tien to `$`. |
| Hien so cu ke ca khi da thoat Claude | Token co `ttl_ms` 6 tieng roi tu het han. Muon xoa ngay thi day lai voi gia tri rong. |
| Hang 1 mat ten tab | Script khong day duoc `$convo`. Kiem tra `--transcript` co duoc truyen khong, va `herdr tab get "$HERDR_TAB_ID"` co tra ve `label` khong. |
| Da `/rename` ma van hien ten tab | Phien do chua render statusline lai. Hoac transcript chua kip ghi `custom-title` - kiem tra bang `grep -c custom-title <transcript>`. |
| Chay `herdr-claude-meta` khong thay gi | Dung - no no-op khi thieu `HERDR_ENV=1` / `HERDR_PANE_ID` / `HERDR_SOCKET_PATH`, tuc khi khong o trong herdr. |

Khong dung CLI `herdr pane report-metadata` de thay the script: parser cua ban
0.8.0 khong nhat quan (`--source` bat buoc dang `--source=X`, `--token` thi
nguoc lai, pane_id positional bi tu choi). Di thang socket JSON-RPC on dinh hon.

## Thiet ke chi tiet

`../claude/docs/superpowers/specs/2026-08-10-herdr-sidebar-account-quota-design.md`
