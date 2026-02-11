return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"mfussenegger/nvim-dap-python",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		dapui.setup()
		require("dap-python").setup("python")

		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		-- Modern breakpoint sign configuration
		vim.fn.sign_define("DapBreakpoint", { text = "⏺", texthl = "DiagnosticError" })
		vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticInfo" })
	end,
}
