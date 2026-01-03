return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "L3MON4D3/LuaSnip",
  },
  config = function()
    local luasnip = require("luasnip")
    local cmp = require("cmp")
    local cmp_select = { behavior = cmp.SelectBehavior.Select }
    local kind_icons = {
      Text = "󰉿",
      Method = "󰆧",
      Function = "󰊕",
      Constructor = "󰢻",
      Field = "󰇽",
      Variable = "󰌿",
      Class = "󰠱",
      Interface = "󰒪",
      Module = "󰏗",
      Property = "󰜢",
      Unit = "󰑭",
      Value = "󰎠",
      Enum = "󰖽",
      Keyword = "󰌋",
      Snippet = "󰅴",
      Color = "󰏘",
      File = "󰈙",
      Reference = "󱅸",
      Folder = "󰉋",
      EnumMember = "󰖽",
      Constant = "󰏿",
      Struct = "",
      Event = "",
      Operator = "󰆕",
      TypeParameter = "󰅲"
    }

    cmp.setup({
      completion = {
        completeopt = "menu,menuone,noinsert",
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = {
          border = "rounded",
          max_height = 15,
          max_width = 60,
        },
      },
      formatting = {
        fields = { "abbr", "kind" },
        format = function(_, vim_item)
          vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
          return vim_item
        end,
      },
      sources = cmp.config.sources({
        { name = "path" },
        { name = "nvim_lsp" },
        { name = "buffer" },
      }),
      mapping = {
        ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
        ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-f>"] = cmp.mapping.scroll_docs(-4),
        ["<C-y>"] = cmp.mapping.confirm({ select = false }),
        ["<C-h>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-l>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-e>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.abort()
          else
            cmp.complete()
          end
        end),
      },
    })
  end,
}
