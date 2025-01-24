return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"microsoft/vscode-js-debug",
		"mxsdev/nvim-dap-vscode-js",
    "nvim-neotest/nvim-nio",
		"rcarriga/nvim-dap-ui",
		"tpope/vim-fugitive",
		"folke/trouble.nvim",
	},
	config = function()
		-- Import dependencies
		local dap = require("dap")
		local dapui = require("dapui")

		-- Setup DAP UI
		dapui.setup()

		-- -- Setup nvim-dap-vscode-js
		-- require("dap-vscode-js").setup({
		-- 	debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
		-- 	adapters = { "pwa-node", "pwa-chrome", "pwa-firefox", "node-terminal" },
		-- })

		-- -- Add TypeScript Debug Configurations
		-- dap.configurations.typescript = {
		-- 	{
		-- 		type = "pwa-node",
		-- 		request = "launch",
		-- 		name = "Launch Program",
		-- 		program = "${file}",
		-- 		cwd = vim.fn.getcwd(),
		-- 		sourceMaps = true,
		-- 		protocol = "inspector",
		-- 		outFiles = { "${workspaceFolder}/dist/**/*.js" },
		-- 	},
		-- 	{
		-- 		type = "pwa-node",
		-- 		request = "attach",
		-- 		name = "Attach to Process",
		-- 		processId = require("dap.utils").pick_process,
		-- 		cwd = vim.fn.getcwd(),
		-- 	},
		-- }
    -- setup adapters
require('dap-vscode-js').setup({
  debugger_path = vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter',
  debugger_cmd = { 'js-debug-adapter' },
  adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
})

local dap = require('dap')

-- custom adapter for running tasks before starting debug
local custom_adapter = 'pwa-node-custom'
dap.adapters[custom_adapter] = function(cb, config)
  if config.preLaunchTask then
      local async = require('plenary.async')
      local notify = require('notify').async

      async.run(function()
          ---@diagnostic disable-next-line: missing-parameter
          notify('Running [' .. config.preLaunchTask .. ']').events.close()
      end, function()
          vim.fn.system(config.preLaunchTask)
          config.type = 'pwa-node'
          dap.run(config)
      end)
  end
end

-- language config
for _, language in ipairs({ 'typescript', 'javascript' }) do
  dap.configurations[language] = {
      {
          name = 'Launch',
          type = 'pwa-node',
          request = 'launch',
          program = '${file}',
          rootPath = '${workspaceFolder}',
          cwd = '${workspaceFolder}',
          sourceMaps = true,
          skipFiles = { '<node_internals>/**' },
          protocol = 'inspector',
          console = 'integratedTerminal',
      },
      {
          name = 'Attach to node process',
          type = 'pwa-node',
          request = 'attach',
          rootPath = '${workspaceFolder}',
          processId = require('dap.utils').pick_process,
      },
      {
          name = 'Debug Main Process (Electron)',
          type = 'pwa-node',
          request = 'launch',
          program = '${workspaceFolder}/node_modules/.bin/electron',
          args = {
              '${workspaceFolder}/dist/index.js',
          },
          outFiles = {
              '${workspaceFolder}/dist/*.js',
          },
          resolveSourceMapLocations = {
              '${workspaceFolder}/dist/**/*.js',
              '${workspaceFolder}/dist/*.js',
          },
          rootPath = '${workspaceFolder}',
          cwd = '${workspaceFolder}',
          sourceMaps = true,
          skipFiles = { '<node_internals>/**' },
          protocol = 'inspector',
          console = 'integratedTerminal',
      },
      {
          name = 'Compile & Debug Main Process (Electron)',
          type = custom_adapter,
          request = 'launch',
          preLaunchTask = 'npm run build-ts',
          program = '${workspaceFolder}/node_modules/.bin/electron',
          args = {
              '${workspaceFolder}/dist/index.js',
          },
          outFiles = {
              '${workspaceFolder}/dist/*.js',
          },
          resolveSourceMapLocations = {
              '${workspaceFolder}/dist/**/*.js',
              '${workspaceFolder}/dist/*.js',
          },
          rootPath = '${workspaceFolder}',
          cwd = '${workspaceFolder}',
          sourceMaps = true,
          skipFiles = { '<node_internals>/**' },
          protocol = 'inspector',
          console = 'integratedTerminal',
      },
  }
end

		-- Auto Open and Close DAP UI
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		-- Debug Keybindings
		vim.keymap.set("n", "<Leader>dt", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
		vim.keymap.set("n", "<Leader>dc", dap.continue, { desc = "Continue Debugging" })
		vim.keymap.set("n", "<Leader>ds", dap.step_over, { desc = "Step Over" })
		vim.keymap.set("n", "<Leader>di", dap.step_into, { desc = "Step Into" })
		vim.keymap.set("n", "<Leader>do", dap.step_out, { desc = "Step Out" })
	end,
}
