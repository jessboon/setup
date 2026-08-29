return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,

    opts = {
      flavour = "mocha",

      transparent_background = true,

      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        telescope = true,
        which_key = true,
        mason = true,

        native_lsp = {
          enabled = true,
        },
      },

      custom_highlights = function(colors)
        return {
          CursorLine = {
            bg = colors.surface0,
          },

          LineNr = {
            fg = colors.overlay1,
          },

          CursorLineNr = {
            fg = colors.green,
            bold = true,
          },

          Comment = {
            fg = colors.overlay1,
            italic = true,
          },

          NormalFloat = {
            bg = colors.mantle,
          },

          FloatBorder = {
            fg = colors.surface1,
            bg = colors.mantle,
          },
        }
      end,
    },
  },
}
