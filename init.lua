-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Easier escape
vim.keymap.set({ "i", "v", "n", "c", "t" }, "jk", "<Esc>")

-- Basic editor options
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.smartindent = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.o.showmode = false
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = "> ", trail = ".", nbsp = "_" }
vim.o.inccommand = "split"
vim.o.cursorline = true
vim.o.scrolloff = 4
vim.o.confirm = true

-- Native 0.12 completion behavior
vim.o.completeopt = "menuone,noselect,popup"
vim.o.autocomplete = true

-- Clipboard sync
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

-- Basic keymaps
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("n", "<leader>w", "<cmd>w!<CR>", { silent = true, desc = "Force [W]rite file" })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("user-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- OpenCode
vim.g.opencode_opts = {}
vim.o.autoread = true

if vim.fn.has("win32") == 1 then
	vim.g.copilot_npx_command = { "npx.cmd" }
end

-- Native plugin manager (Neovim 0.12)
local gh = function(repo)
	return "https://github.com/" .. repo
end

local plugins = {
	gh("NMAC427/guess-indent.nvim"),
	gh("lewis6991/gitsigns.nvim"),
	gh("sindrets/diffview.nvim"),
	gh("NeogitOrg/neogit"),
	gh("nvim-lua/plenary.nvim"),
	gh("folke/which-key.nvim"),
	gh("nvim-telescope/telescope.nvim"),
	gh("nvim-telescope/telescope-ui-select.nvim"),
	gh("nvim-telescope/telescope-file-browser.nvim"),
	gh("stevearc/conform.nvim"),
	gh("windwp/nvim-autopairs"),
	gh("lukas-reineke/indent-blankline.nvim"),
	gh("nickjvandyke/opencode.nvim"),
	{ src = gh("github/copilot.vim"), name = "GithubCopilot" },
	{ src = gh("catppuccin/nvim"), name = "catppuccin" },
	gh("folke/todo-comments.nvim"),
	gh("echasnovski/mini.nvim"),
	gh("nvim-treesitter/nvim-treesitter"),
}

if vim.g.have_nerd_font then
	table.insert(plugins, gh("nvim-tree/nvim-web-devicons"))
end

local pack_errors = {}
for _, spec in ipairs(plugins) do
	local ok, err = pcall(vim.pack.add, { spec }, { confirm = false, load = true })
	if not ok then
		table.insert(pack_errors, tostring(err))
	end
end

if #pack_errors > 0 then
	vim.schedule(function()
		vim.notify("Plugin install had errors. Restart Nvim and run :messages.", vim.log.levels.WARN)
	end)
end

local function prequire(mod)
	local ok, loaded = pcall(require, mod)
	if ok then
		return loaded
	end
	return nil
end

-- Plugin setup
local gitsigns = prequire("gitsigns")
if gitsigns then
	gitsigns.setup({
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "~" },
			changedelete = { text = "~" },
		},
	})
end

local neogit = prequire("neogit")
if neogit then
	neogit.setup({
		kind = "split",
		commit_editor = {
			kind = "auto",
			staged_diff_split_kind = "auto",
		},
		integrations = {
			telescope = true,
			diffview = true,
		},
	})
end

vim.keymap.set("n", "<leader>gg", function()
	local ng = prequire("neogit")
	if ng then
		ng.open({ kind = "split" })
	end
end, { desc = "Open Git UI" })
vim.keymap.set("n", "<leader>gc", "<cmd>Neogit commit<CR>", { desc = "Commit popup" })

local which_key = prequire("which-key")
if which_key then
	which_key.setup({
		delay = 0,
		icons = {
			mappings = vim.g.have_nerd_font,
			keys = vim.g.have_nerd_font and {} or {
				Up = "<Up> ",
				Down = "<Down> ",
				Left = "<Left> ",
				Right = "<Right> ",
				C = "<C-...> ",
				M = "<M-...> ",
				D = "<D-...> ",
				S = "<S-...> ",
				CR = "<CR> ",
				Esc = "<Esc> ",
				ScrollWheelDown = "<ScrollWheelDown> ",
				ScrollWheelUp = "<ScrollWheelUp> ",
				NL = "<NL> ",
				BS = "<BS> ",
				Space = "<Space> ",
				Tab = "<Tab> ",
				F1 = "<F1>",
				F2 = "<F2>",
				F3 = "<F3>",
				F4 = "<F4>",
				F5 = "<F5>",
				F6 = "<F6>",
				F7 = "<F7>",
				F8 = "<F8>",
				F9 = "<F9>",
				F10 = "<F10>",
				F11 = "<F11>",
				F12 = "<F12>",
			},
		},
		spec = {
			{ "<leader>a", group = "[A]I" },
			{ "<leader>g", group = "[G]it" },
			{ "<leader>s", group = "[S]earch" },
			{ "<leader>t", group = "[T]oggle" },
			{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
		},
	})
end

local builtin = prequire("telescope.builtin")
local telescope = prequire("telescope")
if telescope and builtin then
	telescope.setup({
		extensions = {
			file_browser = {
				theme = "ivy",
				hijack_netrw = true,
			},
			["ui-select"] = {
				require("telescope.themes").get_dropdown(),
			},
		},
	})

	pcall(telescope.load_extension, "ui-select")
	local has_file_browser = pcall(telescope.load_extension, "file_browser")

	vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
	vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
	vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
	vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
	vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
	vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
	vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
	vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
	vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
	vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
	vim.keymap.set("n", "<space>e", function()
		if has_file_browser then
			telescope.extensions.file_browser.file_browser()
			return
		end
		builtin.find_files()
	end, { desc = "Open file browser" })
	vim.keymap.set("n", "<leader>/", function()
		builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
			winblend = 10,
			previewer = false,
		}))
	end, { desc = "[/] Fuzzily search in current buffer" })
	vim.keymap.set("n", "<leader>s/", function()
		builtin.live_grep({
			grep_open_files = true,
			prompt_title = "Live Grep in Open Files",
		})
	end, { desc = "[S]earch [/] in Open Files" })
	vim.keymap.set("n", "<leader>sn", function()
		builtin.find_files({ cwd = vim.fn.stdpath("config") })
	end, { desc = "[S]earch [N]eovim files" })
end

local conform = prequire("conform")
if conform then
	conform.setup({
		notify_on_error = false,
		format_on_save = function(bufnr)
			local disable_filetypes = { sql = true, c = true, cpp = true }
			if disable_filetypes[vim.bo[bufnr].filetype] then
				return nil
			end
			return {
				timeout_ms = 500,
				lsp_format = "fallback",
			}
		end,
		formatters_by_ft = {
			lua = { "stylua" },
			c = { "clang-format" },
			cpp = { "clang-format" },
			json = { "clang-format" },
			python = { "isort", "black" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
		},
	})
end

vim.keymap.set({ "n", "v" }, "<leader>f", function()
	local cf = prequire("conform")
	if cf then
		cf.format({ async = true, lsp_format = "fallback" })
	end
end, { desc = "[F]ormat buffer" })

local autopairs = prequire("nvim-autopairs")
if autopairs then
	autopairs.setup({})
end

local ibl = prequire("ibl")
if ibl then
	ibl.setup({})
end

local todo_comments = prequire("todo-comments")
if todo_comments then
	todo_comments.setup({})
end

local mini_ai = prequire("mini.ai")
if mini_ai then
	mini_ai.setup({ n_lines = 500 })
end

local mini_surround = prequire("mini.surround")
if mini_surround then
	mini_surround.setup()
end

local treesitter = prequire("nvim-treesitter.configs")
if treesitter then
	treesitter.setup({
		ensure_installed = {
			"bash",
			"c",
			"diff",
			"html",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"query",
			"vim",
			"vimdoc",
			"yaml",
		},
		auto_install = true,
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = { "ruby" },
		},
		indent = { enable = true, disable = { "ruby" } },
	})
end

vim.keymap.set({ "n", "x" }, "<leader>aa", function()
	require("opencode").ask("@this: ", { submit = true })
end, { desc = "Ask OpenCode" })
vim.keymap.set("n", "<leader>as", function()
	require("opencode").select()
end, { desc = "OpenCode actions" })
vim.keymap.set({ "n", "t" }, "<leader>at", function()
	require("opencode").toggle()
end, { desc = "Toggle OpenCode" })
vim.keymap.set("n", "<leader>an", function()
	require("opencode").command("session.new")
end, { desc = "New OpenCode session" })
vim.keymap.set("n", "<leader>ah", function()
	require("opencode").select_session()
end, { desc = "Select OpenCode session" })
vim.keymap.set("n", "<leader>ai", function()
	require("opencode").command("session.interrupt")
end, { desc = "Interrupt OpenCode" })

-- LSP
vim.diagnostic.config({
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	underline = { severity = vim.diagnostic.severity.ERROR },
	signs = vim.g.have_nerd_font and {
		text = {
			[vim.diagnostic.severity.ERROR] = "E ",
			[vim.diagnostic.severity.WARN] = "W ",
			[vim.diagnostic.severity.INFO] = "I ",
			[vim.diagnostic.severity.HINT] = "H ",
		},
	} or {},
	virtual_text = {
		source = "if_many",
		spacing = 2,
	},
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if not client then
			return
		end

		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
		map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
		if builtin then
			map("grr", builtin.lsp_references, "[G]oto [R]eferences")
			map("gri", builtin.lsp_implementations, "[G]oto [I]mplementation")
			map("grd", builtin.lsp_definitions, "[G]oto [D]efinition")
			map("gO", builtin.lsp_document_symbols, "Open Document Symbols")
			map("gW", builtin.lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
			map("grt", builtin.lsp_type_definitions, "[G]oto [T]ype Definition")
		else
			map("grr", vim.lsp.buf.references, "[G]oto [R]eferences")
			map("gri", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
			map("grd", vim.lsp.buf.definition, "[G]oto [D]efinition")
			map("gO", vim.lsp.buf.document_symbol, "Open Document Symbols")
			map("grt", vim.lsp.buf.type_definition, "[G]oto [T]ype Definition")
		end
		map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

		if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
			local highlight_group = vim.api.nvim_create_augroup("user-lsp-highlight-" .. event.buf, { clear = true })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_group,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_group,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				buffer = event.buf,
				group = vim.api.nvim_create_augroup("user-lsp-detach-" .. event.buf, { clear = true }),
				callback = function()
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = highlight_group, buffer = event.buf })
				end,
			})
		end

		if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
			map("<leader>th", function()
				local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
				vim.lsp.inlay_hint.enable(not enabled, { bufnr = event.buf })
			end, "[T]oggle Inlay [H]ints")
		end

		if client:supports_method(vim.lsp.protocol.Methods.textDocument_completion, event.buf) then
			vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
		end
	end,
})

vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { { ".luarc.json", ".luarc.jsonc" }, "stylua.toml", ".git" },
	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace",
			},
			diagnostics = {
				disable = { "missing-fields" },
			},
		},
	},
})

vim.lsp.config("clangd", {
	cmd = { "clangd" },
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
	root_markers = { ".clangd", "compile_commands.json", "compile_flags.txt", ".git" },
})

vim.lsp.config("pylsp", {
	cmd = { "pylsp" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
})

vim.lsp.config("gopls", {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_markers = { "go.work", "go.mod", ".git" },
	settings = {
		gopls = {
			gofumpt = true,
		},
	},
})

vim.lsp.config("rust_analyzer", {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", ".git" },
	on_attach = function(client, bufnr)
		if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, bufnr) then
			vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
		end
	end,
	settings = {
		["rust-analyzer"] = {
			imports = {
				granularity = {
					group = "module",
				},
				prefix = "self",
			},
			cargo = {
				buildScripts = {
					enable = true,
				},
			},
			procMacro = {
				enable = true,
			},
		},
	},
})

vim.lsp.enable({ "lua_ls", "clangd", "pylsp", "gopls", "rust_analyzer" })

pcall(vim.cmd.colorscheme, "catppuccin-mocha")
