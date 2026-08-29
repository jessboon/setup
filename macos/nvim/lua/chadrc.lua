---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "catppuccin",
  transparency = true,

  hl_override = {
    Normal = {
      bg = "NONE",
    },

    NormalFloat = {
      bg = "NONE",
    },

    LineNr = {
      fg = "grey_fg",
    },

    CursorLineNr = {
      fg = "green",
      bold = true,
    },

    Comment = {
      fg = "grey_fg",
      italic = true,
    },
  },
}

M.ui = {
  statusline = {
    theme = "minimal",
  },

  tabufline = {
    enabled = true,
    lazyload = false,
  },
}

return M
