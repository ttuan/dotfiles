local status, trueZen = pcall(require, "true-zen")
if (not status) then return end

trueZen.setup({})

map("n", "<Leader><Leader>zn", ":TZNarrow<CR>", {})
map("v", "<Leader><Leader>zn", ":'<,'>TZNarrow<CR>", {})
map("n", "<Leader><Leader>zf", ":TZFocus<CR>", {})
map("n", "<Leader><Leader>zm", ":TZMinimalist<CR>", {})
map("n", "<Leader><Leader>za", ":TZAtaraxis<CR>", {})
