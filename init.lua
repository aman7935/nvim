-- Enable netrw for the traditional file explorer experience.
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_2html_plugin = 1

require("core.options")
require("core.keymaps")
require("core.highlights")
require("core.lazy")
require("core.autocmds")
require("cpp").setup()
