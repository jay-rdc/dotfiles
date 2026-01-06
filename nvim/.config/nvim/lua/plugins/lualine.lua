return {
  "nvim-lualine/lualine.nvim",
  config = function()
    require("lualine").setup({
      options = {
        theme = {
          normal = {
            a = "StatusLineSectionA",
            b = "StatusLineSectionB",

            c = { bg = "none" },
          },
          inactive = {
            a = "StatusLineSectionANC",
            b = "StatusLineSectionBNC",
          }
        },
        component_separators = "|",
        section_separators = { left = "", right = "" },
        refresh = { statusline = 300 },
        disabled_filetypes = { statusline = { "alpha" } },
      },
      sections = {
        lualine_a = {
          {
            function() return " " end,
            color = "StatusLineActiveIndicator",
            separator = { left = "", right = "" },
            padding = 0,
          },
          {
            "FugitiveHead",
            icon = "",
          },
        },
        lualine_b = {
          {
            "filetype",
            colored = true,
            icon_only = true,
            separator = "",
            padding = { left = 1, right = 0 },
          },
          {
            "filename",
          },
          {
            "%n",
            icon = "",
          },
          {
            "diff",
          },
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = {
              error = " ",
              warn = " ",
              hint = " ",
              info = " "
            },
          },
        },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {
          {
            "filetype",
            colored = false,
            icon_only = true,
            separator = { left = "" },
            padding = { left = 1, right = 0 },
          },
          {
            "filename",
          },
          {
            "%n",
            icon = "",
          },
          {
            "diff",
          },
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = {
              error = " ",
              warn = " ",
              hint = " ",
              info = " "
            },
          },
        },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
    })
  end
}
