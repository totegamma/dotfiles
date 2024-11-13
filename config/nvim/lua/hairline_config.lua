local cond = require'heirline.conditions'
local utils = require'heirline.utils'

local line_mode = {
    init = function(self)
        self.mode = vim.fn.mode(1)
    end,
    static = {
        vi_mode_text = {
            n = "NORMAL",
            i = "INSERT",
            v = "VISUAL",
            [''] = "V-BLOCK",
            V = "V-LINE",
            c = "COMMAND",
            no = "UNKNOWN",
            s = "UNKNOWN",
            S = "UNKNOWN",
            ic = "UNKNOWN",
            R = "REPLACE",
            Rv = "UNKNOWN",
            cv = "UNKWON",
            ce = "UNKNOWN",
            r = "REPLACE",
            rm = "UNKNOWN",
            t = "INSERT"
        },
        vi_mode_colors = {
            n = 'fg1',
            t = 'fg1',
            i = 'blue',
            v = 'green',
            [''] = 'green',
            V = 'green',
            c = 'fg1',
            R = 'yellow',
            r = 'yellow',
        }
    },
    provider = function(self)
        return " " .. self.vi_mode_text[self.mode] .. " "
    end,
    hl = function(self)
        local mode = self.mode:sub(1, 1)
        return { fg = self.vi_mode_colors[mode], bold = true }
    end,
    condition = function(self)
        return cond.is_active()
    end,
    update = {
        "ModeChanged",
        pattern = "*:*",
        callback = vim.schedule_wrap(function()
            vim.cmd("redrawstatus")
        end),
    }
}

line_pad = {
    provider = function(self)
        return "%="
    end,
    hl = function(self)
        return { fg = 'base_fg', bg = 'base_bg' }
    end,
}

line_pos = {
    provider = function(self)
        return " %l:%c "
    end,
    condition = function(self)
        return cond.is_active()
    end,
    hl = function(self)
        return { fg = 'fg1', bg = 'bg1' }
    end,
}

line_percent = {
    provider = function(self)
        return " %P "
    end,
    condition = function(self)
        return cond.is_active()
    end,
    hl = function(self)
        if cond.is_active() then
            return { fg = 'fg2', bg = 'bg2' }
        else
            return { fg = 'base_fg', bg = 'base_bg' }
        end
    end,
}

line_encoding = {
    provider = function(self)

        local enc = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc
        local typ = vim.bo.filetype

        return " " .. typ .. " " .. enc .. " "
    end,
    hl = function(self)
        return { fg = 'base_fg', bg = 'base_bg' }
    end,
}

line_diagnostics = {

    condition = cond.has_diagnostics,

    static = {
        error_icon = "",
        warn_icon = "",
        info_icon = "",
        hint_icon = "󰌵",
    },

    init = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    end,

    update = { "DiagnosticChanged", "BufEnter" },
    condition = function(self)
        return cond.is_active()
    end,

    hl = { fg = 'base_fg', bg = 'base_bg' },

    {
        provider = " ",
    },
    {
        provider = function(self)
            return self.errors > 0 and (self.error_icon .. " " .. self.errors .. " ")
        end,
        hl = { bg = 'red' },
    },
    {
        provider = function(self)
            return self.warnings > 0 and (self.warn_icon .. " " .. self.warnings .. " ")
        end,
        hl = { bg = 'yellow' },
    },
    {
        provider = function(self)
            return self.info > 0 and (self.info_icon .. " " .. self.info .. " ")
        end,
        hl = { bg = 'cyan' },
    },
    {
        provider = function(self)
            return self.hints > 0 and (self.hint_icon .. " " .. self.hints)
        end,
        hl = { bg = 'blue' },
    },
    {
        provider = " ",
    },
}

line_git = {

    init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
    end,

    condition = function(self)
        return cond.is_active() and cond.is_git_repo()
    end,


    provider = function(self)
        return "  " .. self.status_dict.head .. " "
    end,

    hl = { fg = 'base_fg', bg = 'base_bg' },
}

line_file = {
    provider = function(self)
        local fullpath = vim.api.nvim_buf_get_name(0)
        local filename = vim.fn.fnamemodify(fullpath, ":.")
        if filename == "" then return "[No Name]" end

        local extension = vim.fn.fnamemodify(fullpath, ":e")
        local icon = require("nvim-web-devicons").get_icon(filename, extension, { default = true })

        return " " .. icon .. " " .. filename .. " "
    end,
    hl = function(self)
        if cond.is_active() then
            return { fg = 'fg2', bg = 'bg2' }
        else
            return { fg = 'base_fg', bg = 'base_bg' }
        end
    end,
}

local get_bufs = function()
    return vim.tbl_filter(function(bufnr)
        return vim.api.nvim_get_option_value("buflisted", { buf = bufnr })
    end, vim.api.nvim_list_bufs())
end

local buflist_cache = {}

vim.api.nvim_create_autocmd({ "VimEnter", "UIEnter", "BufAdd", "BufDelete" }, {
    callback = function()
        vim.schedule(function()
            local buffers = get_bufs()
            for i, v in ipairs(buffers) do
                buflist_cache[i] = v
            end
            for i = #buffers + 1, #buflist_cache do
                buflist_cache[i] = nil
            end
        end)
    end,
})

buffer_next = function()
    local current_buf = vim.api.nvim_get_current_buf()
    local current_idx = 1
    for i, buf in ipairs(buflist_cache) do
        if buf == current_buf then
            current_idx = i
            break
        end
    end
    local next_buf = buflist_cache[(current_idx % #buflist_cache) + 1]
    if next_buf then
        vim.api.nvim_set_current_buf(next_buf)
    end
end

buffer_previous = function()
    local current_buf = vim.api.nvim_get_current_buf()
    local current_idx = 1
    for i, buf in ipairs(buflist_cache) do
        if buf == current_buf then
            current_idx = i
            break
        end
    end
    local next_buf = buflist_cache[(current_idx - 2) % #buflist_cache + 1]
    if next_buf then
        vim.api.nvim_set_current_buf(next_buf)
    end
end

buffer_close = function()
    local current_buf = vim.api.nvim_get_current_buf()
    local current_idx = 1
    for i, buf in ipairs(buflist_cache) do
        if buf == current_buf then
            current_idx = i
            break
        end
    end
    local next_buf = buflist_cache[(current_idx - 1) % #buflist_cache + 1]
    if next_buf then
        vim.api.nvim_set_current_buf(next_buf)
    end
    vim.api.nvim_command("bd! " .. current_buf)
end

vim.cmd("command! BufferNext lua buffer_next()")
vim.cmd("command! BufferPrevious lua buffer_previous()")
vim.cmd("command! BufferClose lua buffer_close()")

generate_tabs = function()
    local tabs = {}
    for i, bufnr in ipairs(buflist_cache) do

        local bufname = vim.api.nvim_buf_get_name(bufnr)

        table.insert(tabs, {
            hl = function()
                local selected = vim.api.nvim_get_current_buf() == bufnr
                local modified = vim.api.nvim_buf_get_option(bufnr, "modified")
                if modified then
                    return { fg = 'base_fg', bg = 'red' }
                else
                    if selected then
                        return { fg = 'base_fg', bg = 'white' }
                    else
                        return { fg = 'base_fg', bg = 'bg2' }
                    end
                end
            end,
            {
                provider = function()
                    return "▎"
                end,
                hl = function()
                    if vim.api.nvim_get_current_buf() == bufnr then
                        return { bg = 'green' }
                    else
                        return { bg = 'base_bg' }
                    end
                end,
            },

            {
                provider = function()
                    local icon = require("nvim-web-devicons").get_icon(bufname, vim.fn.fnamemodify(bufname, ":e"), { default = true })
                    return " " .. icon .. " "
                end,
                hl = function()
                    local icon, color = require("nvim-web-devicons").get_icon_color(vim.fn.fnamemodify(bufname, ":e"))
                    return { bg = color }
                end,
            },

            {
                provider = function()
                    local filename = vim.fn.fnamemodify(bufname, ":t")
                    if filename == "" then return "[No Name]" end
                    return " " .. filename .. " "
                end,
            },

            {
                provider = function()
                    local modified = vim.api.nvim_buf_get_option(bufnr, "modified")
                    return modified and " ● " or " 󰅖 "
                end,
            }
        })
    end

    return tabs
end

tabs = {
    init = function(self)
        tabs = generate_tabs()
        for i, tab in ipairs(tabs) do
            self[i] = self:new(tab)
        end
        if #self > #tabs then
            for i = #tabs + 1, #self do
                self[i] = nil
            end
        end
    end,
}

require('heirline').setup({
    statusline = {
        {
            line_mode,
            line_file,
            line_git,
        },
        line_pad,
        {
            line_diagnostics,
            line_encoding,
            line_percent,
            line_pos,
        },
    },
    tabline = {
        tabs,
    },
    opts = {
        colors = {
            black        = '#161821',
            red          = '#E27878',
            green        = '#B4BE82',
            yellow       = '#E2A478',
            blue         = '#84A0C6',
            purple       = '#A093C7',
            cyan         = '#89B8C2',
            white        = '#C6C8D1',
            brightBlack  = '#6B7089',
            brightRed    = '#E98989',
            brightGreen  = '#C0CA8E',
            brightYellow = '#E9B189',
            brightBlue   = '#91ACD1',
            brightPurple = '#ADA0D3',
            brightCyan   = '#95C4CE',
            brightWhite  = '#D2D4DE',
            -- なぜかheirlineは前後の色が逆
            base_fg      = '#0f1117',
            base_bg      = '#3e445e',
            fg1          = '#818596',
            fg2          = '#2e313f',
            bg1          = '#17171b',
            bg2          = '#6b7089',
        }
    }
})

vim.o.showtabline = 2
