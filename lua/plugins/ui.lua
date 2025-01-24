return {
  -- messages, cmdline and the popupmenu
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
      { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    },
    opts = {
      -- lsp = {
      --   override = {
      --     ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      --     ["vim.lsp.util.stylize_markdown"] = true,
      --     ["cmp.entry.get_documentation"] = true,
      --   },
      -- },
      -- routes = {
      --   {
      --     filter = {
      --       event = "msg_show",
      --       any = {
      --         { find = "%d+L, %d+B" },
      --         { find = "; after #%d+" },
      --         { find = "; before #%d+" },
      --       },
      --     },
      --     view = "mini",
      --   },
      -- },
      -- presets = {
      --   bottom_search = true,
      --   command_palette = true,
      --   long_message_to_split = true,
      -- },
      -- file = {
      --   [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
      --   ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
      -- },
      -- filetype = {
      --   dotenv = { glyph = "", hl = "MiniIconsYellow" },
      -- },
      -- indent = { enabled = true },
      -- input = { enabled = true },
      -- notifier = { enabled = true },
      -- scope = { enabled = true },
      -- scroll = { enabled = true },
      -- statuscolumn = { enabled = false }, -- we set this in options.lua
      -- toggle = { map = LazyVim.safe_keymap_set },
      -- words = { enabled = true },
      options = {
        -- stylua: ignore
        close_command = function(n) Snacks.bufdelete(n) end,
        -- stylua: ignore
        right_mouse_command = function(n) Snacks.bufdelete(n) end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        diagnostics_indicator = function(_, _, diag)
          local icons = LazyVim.config.icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
        ---@param opts bufferline.IconFetcherOpts
        get_element_icon = function(opts)
          return LazyVim.config.icons.ft[opts.filetype]
        end,
      },
      -- dashboard = {
      --   preset = {
      --     pick = function(cmd, opts)
      --       return LazyVim.pick(cmd, opts)()
      --     end,
      --     header = [[
      --       ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
      --       ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z    
      --       ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z       
      --       ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z         
      --       ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║           
      --       ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝           
      --     ]],
      --     -- stylua: ignore
      --     ---@type snacks.dashboard.Item[]
      --     keys = {
      --       { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
      --       { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
      --       { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
      --       { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
      --       { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
      --       { icon = " ", key = "s", desc = "Restore Session", section = "session" },
      --       { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
      --       { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
      --       { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      --     },
      --   },
      -- },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
  }
}
