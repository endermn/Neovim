local save = require("auto-save")
save.setup({
	enabled = _G.enable_autosave,
	execution_message = {
		enabled = false,
	},
	debounce_delay = 1000,
})
