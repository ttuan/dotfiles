# Hien account Claude + quota 5h tren sidebar herdr

Ngay: 2026-08-10
Trang thai: da trien khai. Huong dan cai dat lai o `herdr/README.md`.

## Van de

Sidebar herdr dang hien workspace/tab va state/agent cho moi pane. Khi chay
nhieu account Claude song song (`~/.claude`, `~/.claude-work`,
`~/.claude-alt`), khong nhin ra pane nao dang dung account nao, cung khong
biet account do da tieu bao nhieu quota 5h. Phai nhay vao tung pane doc
statusline moi biet.

## Muc tieu

Them 2 hang vao khoi agent trong sidebar, chi cho pane Claude:

```
|<--------- 26 cot -------->|
my-project        agents
⠐ working           claude
👤 tuantv.nhnd
📊 5h 42% (3h12m)
```

- Hang 3: dinh danh account (email rut gon, kem org neu la org that)
- Hang 4: quota 5h, phan tram + thoi gian con lai toi luc reset, to mau theo
  nguong

Phai dung cho ca 3 config dir, moi pane hien dung account cua chinh no.

## Kien truc

```
Claude Code (pane, CLAUDE_CONFIG_DIR=~/.claude-work)
   │  moi lan render statusline
   ▼
~/.claude-work/statusline-command.sh
   │  da co san: $account_email, $account_org, $FIVE_H, $FIVE_H_RESET
   │  them 1 khoi goi o cuoi, chay nen (&)
   ▼
~/.local/bin/herdr-claude-meta
   │  doc $HERDR_PANE_ID + $HERDR_SOCKET_PATH tu env cua pane
   │  format lai chuoi hien thi, chon mau theo nguong
   ▼
unix socket -> herdr server:  pane.report_metadata
   ▼
sidebar hang 3 + 4
```

Diem mau chot: **moi pane tu khai bao metadata cua chinh no**. Env
`HERDR_PANE_ID` do herdr set san trong pane, nen khong can map thu cong
"config dir nao <-> pane nao". Account nao chay o pane nao la tu dong dung.

### Cac phuong an da loai

- **Goi thang CLI `herdr pane report-metadata`**: parser cua ban 0.8.0 khong
  nhat quan - `--source` bat buoc dang `--source=X` (dang cach bao "unknown
  option"), con `--token` thi nguoc lai, va pane_id positional bi tu choi trong
  moi to hop da thu. Di thang socket JSON-RPC on dinh hon va giong het cach
  hook `herdr-agent-state.sh` do chinh herdr cai dat dang lam.
- **Daemon quet pane roi day metadata**: khong co cach nao biet pane nao dung
  config dir nao tu ben ngoai.
- **Hook Claude Code (SessionStart/Stop)**: chi cap nhat theo su kien nen quota
  dung yen giua cac luot, va phai lap lai viec doc keychain + curl ma
  statusline da lam roi.
- **Gop 3 statusline thanh 1 file trong dotfiles**: dung la chung dang trung
  lap va lech nhau, nhung do la viec don dep rieng, khong phuc vu muc tieu nay.
  Ghi lai o phan "Viec de lai sau".

## Thanh phan 1 - script `herdr-claude-meta`

File nguon: `dotfiles/herdr/herdr-claude-meta.sh`
Symlink: `~/.local/bin/herdr-claude-meta` (khai bao trong `install.conf.yaml`)

### Giao dien

```
herdr-claude-meta --email <EMAIL> --org <ORG> --five-pct <NUM> --five-reset <ISO8601>
```

Moi tham so deu khong bat buoc. Script **thoat 0 im lang** khi:

- `HERDR_ENV` khac `1`, hoac thieu `HERDR_PANE_ID` / `HERDR_SOCKET_PATH`
  (dang chay ngoai herdr)
- khong co `python3`
- socket khong ket noi duoc

Khong bao gio in ra stdout/stderr, khong bao gio tra ve ma loi khac 0 - no la
phan phu cua statusline, hong thi phai hong im lang.

Cach hien thuc: `sh` + heredoc `python3`, bam theo dung khuon cua
`~/.claude/hooks/herdr-agent-state.sh` (hook do chinh herdr cai) - script do da
lam san viec mo unix socket, gui 1 dong JSON, doc phan hoi roi dong.

### Payload

```json
{
  "id": "claude-meta:<epoch_ms>:<rand6>",
  "method": "pane.report_metadata",
  "params": {
    "pane_id": "<HERDR_PANE_ID>",
    "source": "claude-meta",
    "seq": "<time_ns>",
    "ttl_ms": 21600000,
    "tokens": {
      "acct": "👤 tuantv.nhnd",
      "quota_ok": "📊 5h 42% (3h12m)",
      "quota_warn": null,
      "quota_crit": null
    }
  }
}
```

- `seq` lay `time.time_ns()` de bao cao den muon khong ghi de bao cao moi hon.
- `ttl_ms = 21600000` (6 gio) dai hon cua so 5h, nen pane con song khong bao gio
  cham nguong con pane da chet thi tu don hang cua no.
- Token gui `null` la lenh xoa token do.

Rang buoc tu API schema (`PaneReportMetadataParams`): toi da 16 token, ten token
khop `^[A-Za-z0-9_-]{1,32}$`, `ttl_ms` toi da 86400000.

### Quy tac format

**Token `acct`:**

1. Bo hau to `'s Organization` / `’s Organization` khoi org. Neu phan con lai
   bang email thi day la org tu sinh cua tai khoan ca nhan - coi nhu khong co
   org.
2. Lay phan truoc `@` cua email.
3. Con org that thi ghep `<local> · <org>`, khong thi de mot minh `<local>`.
4. Them tien to `👤 `.
5. Cat con 26 o hien thi: cat giua phan local-part, chen `…`.
6. Khong co email thi gui `acct: null` - hang 3 bien mat thay vi hien
   `unknown`.

Ket qua tren 3 account that:

| Config dir | Email | Org | Hien thi |
|---|---|---|---|
| `~/.claude` | tran.van.tuan@sun-asterisk.com | Sun VN01 | `👤 tran.van.tuan · Sun VN01` -> cat con `👤 tran.va…tuan · Sun VN01` |
| `~/.claude-work` | tuantv.nhnd@gmail.com | tu sinh | `👤 tuantv.nhnd` |
| `~/.claude-alt` | alice@example.com | tu sinh | `👤 alice` |

**Token quota:**

Phan tram lam tron ve so nguyen. Chon token theo nguong, hai token con lai gui
`null`:

| Phan tram | Token | Mau |
|---|---|---|
| < 70 | `quota_ok` | `#9ece6a` xanh |
| 70 - 89 | `quota_warn` | `#F49D00` cam (dung `yellow` cua theme.custom) |
| >= 90 | `quota_crit` | `#f7768e` do |

Chuoi: `📊 5h {pct}% ({con_lai})`. Thoi gian con lai tinh tu `resets_at`
(ISO8601), rut gon 2 don vi lon nhat: `1d2h`, `3h12m`, `47m`. Het cua so hoac
khong co `resets_at` thi bo ngoac: `📊 5h 42%`.

Khong lay duoc phan tram thi gui ca 3 token `null` - hang 4 bien mat.

### Vi sao phai 3 token cho quota

Style token trong `config.toml` la tinh (`RawStyledSidebarToken` chi co
`token`, `fg`, `bold`, `dim`) - khong the doi mau theo gia tri nhu
`state_icon`/`state_text` (hai token dung san do duoc herdr gan cung mau theo
state). Cach lach: khai 3 ten token cho 3 muc, moi ten mot mau co dinh, moi lan
chi dien dung mot cai. Ket qua nhin y het mau dong.

## Thanh phan 2 - moc goi trong statusline

Them nguyen khoi nay vao **cuoi ca 3 file** `~/.claude/statusline-command.sh`,
`~/.claude-work/statusline-command.sh`, `~/.claude-alt/statusline-command.sh`.
Khoi giong het nhau o ca ba vi ca ba deu dat cung ten bien
(`account_email`, `account_org`, `FIVE_H`, `FIVE_H_RESET`) - da xac nhan bang
grep.

```sh
# Day dinh danh account + quota 5h sang sidebar herdr.
# Chay nen de khong lam cham statusline; no-op khi khong o trong herdr.
if [ -x "$HOME/.local/bin/herdr-claude-meta" ]; then
  "$HOME/.local/bin/herdr-claude-meta" \
    --email "$account_email" \
    --org "$account_org" \
    --five-pct "$FIVE_H" \
    --five-reset "$FIVE_H_RESET" >/dev/null 2>&1 &
fi
```

Ba file nay khong nam trong dotfiles nen phai sua tay tung file. Chung khac
nhau o cho khac (`~/.claude` dung `claude auth status`, hai file kia hardcode
keychain entry rieng), nhung khoi them vao thi giong het.

## Thanh phan 3 - `config.toml`

Sua `dotfiles/herdr/config.toml` (symlink sang `~/.config/herdr/config.toml`).
Giu nguyen `rows` chung, them `rows_by_agent` rieng cho claude de pane cua agent
khac (copilot, cursor - deu co hook herdr trong may nay) khong bi hai hang
trong.

```toml
[ui.sidebar.agents]
rows = [["workspace", "tab"], ["state_icon", "state_text", "agent"]]

# Rieng pane Claude: them hang account + hang quota 5h. Gia tri do
# ~/.local/bin/herdr-claude-meta day vao qua pane.report_metadata moi lan
# statusline render. Quota tach lam 3 token vi style token la tinh - moi lan
# chi mot token co gia tri, hai token con lai bi xoa.
[ui.sidebar.agents.rows_by_agent]
claude = [
  ["workspace", "tab"],
  ["state_icon", "state_text", "agent"],
  [{ token = "$acct", dim = true }],
  [
    { token = "$quota_ok",   fg = "#9ece6a" },
    { token = "$quota_warn", fg = "#F49D00" },
    { token = "$quota_crit", fg = "#f7768e" },
  ],
]
```

Giu `sidebar_width` mac dinh 26 cot. Noi dung da duoc thiet ke de vua 26 cot
nen khong phai an them be ngang cua vung terminal.

## Thanh phan 4 - `install.conf.yaml`

Them link ben canh muc herdr da co:

```yaml
    ~/.local/bin/herdr-claude-meta:
      create: true
      relink: true
      path: herdr/herdr-claude-meta.sh
```

## Kiem chung

Ba dieu chua the xac nhan tinh khi chua sua config, phai kiem tra ngay khi
trien khai. **Ket qua thuc te:**

1. **`herdr config check` co chap nhan token `$acct` va cu phap bang style
   khong.** DUOC - tra ve `config: ok` voi ca `{ token = "$acct", dim = true }`.
2. **Hang co token rong hien ra sao.** Khong co van de trong thuc te. Pane chua
   report thi chi hien 2 hang nhu cac agent khac; token xuat hien ngay o lan
   render statusline dau tien cua pane do. Khoang trong nay chi anh huong cac
   pane da mo san tu truoc luc cai dat, moi pane mot lan.
3. **`herdr server reload-config` co ap dung duoc `rows_by_agent` khong.** DUOC -
   tra ve `status: "applied"`, `diagnostics: []`. Khong can khoi dong lai
   session.

Da chay that dau-cuoi: pane `CLAUDE_CONFIG_DIR=~/.claude-work` tu day len
`{"acct": "👤 tuantv.nhnd", "quota_ok": "📊 5h 23% (43m)"}` qua statusline that,
khong phai gia tri bom tay.

Cach chay thu:

```sh
herdr config check                       # buoc 1
herdr server reload-config               # buoc 3
herdr pane get "$HERDR_PANE_ID"          # doc lai tokens da day
```

Ma tran test - ca 3 account deu co tren may nay, mo 1 pane cho moi config dir
va xac nhan tung pane hien dung email cua no:

| Pane | Lenh | Ky vong hang 3 |
|---|---|---|
| A | `claude` | `👤 tran.va…tuan · Sun VN01` |
| B | `CLAUDE_CONFIG_DIR=~/.claude-work claude` | `👤 tuantv.nhnd` |
| C | `CLAUDE_CONFIG_DIR=~/.claude-alt claude` | `👤 alice` |

Test mau nguong bang cach goi tay, khong cho quota that:

```sh
herdr-claude-meta --email a@b.com --five-pct 42 --five-reset ""   # xanh
herdr-claude-meta --email a@b.com --five-pct 78 --five-reset ""   # cam
herdr-claude-meta --email a@b.com --five-pct 95 --five-reset ""   # do
```

Test truong hop hong: chay `herdr-claude-meta` ngoai herdr (`HERDR_ENV` khong
set) phai thoat 0, khong in gi.

## Rollback

```sh
cd ~/code/dotfiles && git checkout herdr/config.toml && herdr server reload-config
```

Ba file statusline khong o trong git, go tay khoi goi da them. Token da day
van con toi da 6 tieng roi tu het han.

## Viec de lai sau

Ba file `~/.claude*/statusline-command.sh` dang trung lap va da lech nhau:
`~/.claude` dung `claude auth status` (nhan biet duoc khi doi account),
`~/.claude-work` va `~/.claude-alt` con hardcode keychain entry va doc
`.claude.json`. Nen gop ve mot file trong dotfiles roi symlink vao ca ba, chi
de khac biet o bien moi truong. Viec nay doc lap voi tinh nang nay.
