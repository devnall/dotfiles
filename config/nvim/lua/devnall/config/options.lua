local function assign(dest, src)
	for k, v in pairs(src) do
		dest[k] = v
	end
end

assign(vim.g, {
	bigfile_size = 1024 * 1024 * 0.5,
	-- defaults
	ux_piped_input = 0,

	-- lazy defaults
	lazyvim_cmp = "blink.cmp",
	ai_cmp = true,
})

-- assign options
assign(vim.opt, {
	listchars = {
		-- space = "·",
		tab = "▏ ",
	},

	tabstop = 4,
	shiftwidth = 4,
	softtabstop = 4,
	expandtab = false,
	smarttab = true,
	smartcase = true,
	smartindent = true,

	wrap = false,
	completeopt = "menu,menuone,popup,noinsert",
	colorcolumn = "101,121",
	signcolumn = "yes:2",
	scrolloff = 10,
})
