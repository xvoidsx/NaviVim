-- UI: statusline, tabs, dashboard, guides (VSCode comfort).
--
-- The dashboard is NaviVim's front door: shortcut buttons, a random tip
-- of the day, and a little Wired celebration (boot reveal + neon cycling)
-- on every launch. See HANDBOOK.md for the full user guide.

-- Full welcome art. Shared by the spec below and the boot animation.
local navi_header_full = {
  " _   _             ___     ___           ",
  "| \\ | | __ ___   _(_) \\   / (_)_ __ ___  ",
  "|  \\| |/ _` \\ \\ / / |\\ \\ / /| | '_ ` _ \\ ",
  "| |\\  | (_| |\\ V /| | \\ V / | | | | | | |",
  "|_| \\_|\\__,_| \\_/ |_|  \\_/  |_|_| |_| |_|",
  "",
  "  Close the world. Open the Wired.",
}

-- Tip of the day: one is picked at random on every launch.
local navi_tips = {
  "toggle the sidebar with <C-n> or <Space> e",
  "turn autocomplete on/off with <Space> u a",
  "press <Space> and wait — which-key shows everything",
  "search this file with /, clear the highlight with <Esc>",
  "teleport with s (flash-jump)",
  "grep the whole project with <Space> f g",
  "gd jumps to definition, K shows docs",
  "rename any symbol with <Space> r n",
  "open LazyGit with <Space> g g",
  "format-on-save toggles with <Space> u f",
  "move lines with Alt+j / Alt+k",
  "comment lines with gcc, selections with gc",
  "your theme lives in ~/.config/omaterm/nvim.theme",
}

-- Stashed dashboard header section so the boot animation can redraw it.
local navi_header_sec = nil

return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = { theme = "auto", globalstatus = true },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    },
  },
  {
    -- Welcome screen for Navi newcomers
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = navi_header_full
      dashboard.section.header.opts.hl = "NaviVimHeader"
      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find file         <leader>ff", ":Telescope find_files<CR>"),
        dashboard.button("e", "  File explorer     <leader>e ", ":NvimTreeToggle<CR>"),
        dashboard.button("g", "  Grep project      <leader>fg", ":Telescope live_grep<CR>"),
        dashboard.button("b", "  Buffers           <leader>fb", ":Telescope buffers<CR>"),
        dashboard.button("t", "  Terminal          <leader>tt", ":ToggleTerm<CR>"),
        dashboard.button("m", "  Language servers  :Mason    ", ":Mason<CR>"),
        dashboard.button("p", "  Plugins           :Lazy     ", ":Lazy<CR>"),
        dashboard.button("q", "  Quit              :qa       ", ":qa<CR>"),
      }
      math.randomseed(os.time() + vim.fn.getpid())
      dashboard.section.footer.val = { "", "  » TIP: " .. navi_tips[math.random(#navi_tips)] }
      dashboard.section.footer.opts.hl = "NaviVimTip"
      navi_header_sec = dashboard.section.header
      return dashboard.config
    end,
    config = function(_, opts)
      vim.api.nvim_set_hl(0, "NaviVimHeader", { fg = "#ff10f0" })
      vim.api.nvim_set_hl(0, "NaviVimTip", { fg = "#39ff14" })
      require("alpha").setup(opts)
      -- Wired welcome: only with our house theme, never headless.
      if vim.g.colors_name ~= "nightshadeNeon" then
        return
      end
      if #vim.api.nvim_list_uis() == 0 then
        return
      end
      if navi_header_sec == nil then
        return
      end
      local sec = navi_header_sec
      local total = #navi_header_full
      local blank = {}
      for _ in ipairs(navi_header_full) do
        blank[#blank + 1] = ""
      end
      sec.val = blank
      local shown = 0
      local neon = { "#ff10f0", "#39ff14", "#00ffff" }
      local boot_tid
      boot_tid = vim.fn.timer_start(140, function()
        local ok = pcall(function()
          if vim.bo.filetype ~= "alpha" then
            error("left dashboard")
          end
          shown = shown + 1
          local partial = {}
          for idx, line in ipairs(navi_header_full) do
            partial[idx] = idx <= shown and line or ""
          end
          sec.val = partial
          require("alpha").redraw()
        end)
        if not ok then
          -- Ba-bye, animation: restore full art (harmless off-dashboard) and stop.
          sec.val = navi_header_full
          vim.fn.timer_stop(boot_tid)
          return
        end
        if shown >= total then
          vim.fn.timer_stop(boot_tid)
          -- Celebration: cycle the logo through the neon palette until
          -- the user leaves the dashboard.
          local ci = 0
          local neon_tid
          neon_tid = vim.fn.timer_start(500, function()
            if vim.bo.filetype ~= "alpha" then
              vim.fn.timer_stop(neon_tid)
              return
            end
            ci = (ci % #neon) + 1
            vim.api.nvim_set_hl(0, "NaviVimHeader", { fg = neon[ci] })
          end, { ["repeat"] = -1 })
        end
      end, { ["repeat"] = -1 })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
}
