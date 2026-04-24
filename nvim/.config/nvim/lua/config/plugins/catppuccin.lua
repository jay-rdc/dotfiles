require("catppuccin").setup({
  flavour = "mocha",
  transparent_background = true,
  float = { transparent = true },
  custom_highlights = function(colors)
    return {
      LineNr = { fg = colors.blue },
      LineNrAbove = { fg = colors.surface2 },
      LineNrBelow = { fg = colors.surface2 },
      StatusLineActiveIndicator = { fg = colors.pink, bg = colors.pink },
      StatusLineSectionA = { fg = colors.pink, bg = colors.surface0 },
      StatusLineSectionB = { fg = colors.pink, bg = colors.base },
      StatusLineSectionANC = { fg = colors.overlay0, bg = colors.surface0 },
      StatusLineSectionBNC = { fg = colors.overlay0, bg = colors.base },
    }
  end,
})

vim.cmd.colorscheme("catppuccin")
