local lsp = require('feline.providers.lsp')
local vi_mode_utils = require('feline.providers.vi_mode')
local colors = {
    black=        '#161821',
    red=          '#E27878',
    green=        '#B4BE82',
    yellow=       '#E2A478',
    blue=         '#84A0C6',
    purple=       '#A093C7',
    cyan=         '#89B8C2',
    white=        '#C6C8D1',
    brightBlack=  '#6B7089',
    brightRed=    '#E98989',
    brightGreen=  '#C0CA8E',
    brightYellow= '#E9B189',
    brightBlue=   '#91ACD1',
    brightPurple= '#ADA0D3',
    brightCyan=   '#95C4CE',
    brightWhite=  '#D2D4DE',
    fg1= '#17171b',
    fg2= '#6b7089',
    fg3= '#3e445e',
    bg1= '#818596',
    bg2= '#2e313f',
    bg3= '#0f1117',
    fg= '#3e445e',
    bg= '#0f1117'
}

local vi_mode_colors = {
    NORMAL        = '#818596',--'green',
    OP            = '#818596',--'green',
    INSERT        = '#84a0c6',--'red',
    CONFIRM       = '#818596',--'red',
    VISUAL        = '#b4be82',--'skyblue',
    LINES         = '#b4be82',--'skyblue',
    BLOCK         = '#b4be82',--'skyblue',
    REPLACE       = '#e2a478',--'violet',
    ['V-REPLACE'] = '#e2a478',--'violet',
    ENTER         = '#818596',--'cyan',
    MORE          = '#818596',--'cyan',
    SELECT        = '#818596',--'orange',
    COMMAND       = '#818596',--'green',
    SHELL         = '#818596',--'green',
    TERM          = '#818596',--'green',
    NONE          = '#818596'--'yellow'
}

local vi_mode_text = {
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
}


local components = {
    active = {{}, {}, {}},
    inactive = {{}, {}, {}},
}

-- vi-mode
components.active[1][1] = {
    provider = function()
        return ' ' .. vi_mode_text[vim.fn.mode()] .. ' '
    end,
    hl = function()
        local val = {}

        val.bg = vi_mode_utils.get_mode_color()
        val.fg = colors.fg1
        val.style = 'bold'

        return val
    end,

}

-- fileIcon
components.active[1][2] = {
    provider = function()
        local filename = vim.fn.expand('%:t')
        local extension = vim.fn.expand('%:e')
        local icon  = require'nvim-web-devicons'.get_icon(filename, extension)
        if icon == nil then
            icon = ''
        end
        return ' ' .. icon .. ' '
    end,
    hl = {
        fg = colors.fg2,
        bg = colors.bg2,
        style = 'bold'
    },
}

-- filename
components.active[1][3] = {
    provider = function()
        return vim.fn.expand("%:F")
    end,
    hl = {
        fg = colors.fg2,
        bg = colors.bg2,
        style = 'bold'
    },
    right_sep = {
        str = ' ',
        hl = {
            fg = colors.fg2,
            bg = colors.bg2,
        }
    }
}

-- gitBranch
components.active[1][4] = {
    provider = 'git_branch',
    hl = {
        fg = colors.fg2,
        bg = colors.bg3,
        style = 'bold'
    },
    left_sep = {
        str = ' ',
        hl = {
            fg = colors.fg3,
            bg = colors.bg3,
        }
    },
    right_sep = {
        str = ' ',
        hl = {
            fg = colors.fg3,
            bg = colors.bg3,
        }
    }
}

-- RIGHT
components.active[3][1] = {
    provider = 'diagnostic_errors',
    enabled = function()
        return lsp.diagnostics_exist('ERROR')
    end,
    hl = {
        fg = colors.red,
        bg = colors.bg3,
        style = 'bold'
    },
    right_sep = {
        str = ' ',
        hl = {
            fg = colors.fg3,
            bg = colors.bg3,
        }
    }
}

components.active[3][2] = {
    provider = 'diagnostic_warnings',
    enabled = function()
        return lsp.diagnostics_exist('WARN')
    end,
    hl = {
        fg = colors.red,
        bg = colors.bg3,
        style = 'bold'
    },
    right_sep = {
        str = ' ',
        hl = {
            fg = colors.fg3,
            bg = colors.bg3,
        }
    }
}

components.active[3][3] = {
    provider = 'diagnostic_info',
    enabled = function()
        return lsp.diagnostics_exist('INFO')
    end,
    hl = {
        fg = colors.blue,
        bg = colors.bg3,
        style = 'bold'
    },
    right_sep = {
        str = ' ',
        hl = {
            fg = colors.fg3,
            bg = colors.bg3,
        }
    }
}

components.active[3][4] = {
    provider = 'diagnostic_hints',
    enabled = function()
        return lsp.diagnostics_exist('HINT')
    end,
    hl = {
        fg = colors.cyan,
        bg = colors.bg3,
        style = 'bold'
    },
    right_sep = {
        str = ' ',
        hl = {
            fg = colors.fg3,
            bg = colors.bg3,
        }
    }
}

-- fileSize
components.active[3][5] = {
    provider = 'file_size',
    enabled = function() return vim.fn.getfsize(vim.fn.expand('%:t')) > 0 end,
    hl = {
        fg = colors.fg3,
        bg = colors.bg3,
        style = 'bold'
    },
    left_sep = {
        str = ' ',
        hl = {
            fg = colors.fg3,
            bg = colors.bg3,
        }
    },
    right_sep = {
        str = ' ',
        hl = {
            fg = colors.fg3,
            bg = colors.bg3,
        }
    }
}

-- fileFormat
components.active[3][6] = {
    provider = function() return '' .. vim.bo.fileformat:upper() .. '' end,
    hl = {
        fg = colors.fg3,
        bg = colors.bg3,
        style = 'bold'
    },
    left_sep = {
        str = ' ',
        hl = {
            fg = colors.fg3,
            bg = colors.bg3,
        }
    },
    right_sep = {
        str = ' ',
        hl = {
            fg = colors.fg3,
            bg = colors.bg3,
        }
    }
}

-- fileEncode
components.active[3][7] = {
    provider = 'file_encoding',
    hl = {
        fg = colors.fg3,
        bg = colors.bg3,
        style = 'bold'
    },
    left_sep = {
        str = ' ',
        hl = {
            fg = colors.fg3,
            bg = colors.bg3,
        }
    },
    right_sep = {
        str = ' ',
        hl = {
            fg = colors.fg3,
            bg = colors.bg3,
        }
    }
}

-- linePercent
components.active[3][8] = {
    provider = 'line_percentage',
    hl = {
        fg = colors.fg2,
        bg = colors.bg2,
        style = 'bold'
    },
    left_sep = {
        str = ' ',
        hl = {
            fg = colors.fg2,
            bg = colors.bg2,
        }
    },
    right_sep = {
        str = ' ',
        hl = {
            fg = colors.fg2,
            bg = colors.bg2,
        }
    }

}

-- position
components.active[3][9] = {
    provider = 'position',
    hl = {
        fg = colors.fg1,
        bg = colors.bg1,
        style = 'bold'
    },
    left_sep = {
        str = ' ',
        hl = {
            fg = colors.fg1,
            bg = colors.bg1,
        }
    },
    right_sep = {
        str = ' ',
        hl = {
            fg = colors.fg1,
            bg = colors.bg1,
        }
    }
}

------------------------------------

-- fileIcon
components.inactive[1][1] = {
    provider = function()
        local filename = vim.fn.expand('%:t')
        local extension = vim.fn.expand('%:e')
        local icon  = require'nvim-web-devicons'.get_icon(filename, extension)
        if icon == nil then
            icon = ''
        end
        return ' ' .. icon .. ' '
    end,
    hl = {
        fg = colors.fg3,
        bg = colors.bg3,
    },
}

-- filename
components.inactive[1][2] = {
    provider = function()
        return vim.fn.expand("%:F")
    end,
    hl = {
        fg = colors.fg3,
        bg = colors.bg3,
    },
    right_sep = {
        str = ' ',
        hl = {
            fg = colors.fg3,
            bg = colors.bg3,
        }
    }
}

-- fileFormat
components.inactive[3][1] = {
    provider = function() return '' .. vim.bo.fileformat:upper() .. '' end,
    hl = {
        fg = colors.fg3,
        bg = colors.bg3,
        style = 'bold'
    },
    left_sep = {
        str = ' ',
        hl = {
            fg = colors.fg3,
            bg = colors.bg3,
        }
    },
    right_sep = {
        str = ' ',
        hl = {
            fg = colors.fg3,
            bg = colors.bg3,
        }
    }

}
-- fileEncode
components.inactive[3][2] = {
    provider = 'file_encoding',
    hl = {
        fg = colors.fg3,
        bg = colors.bg3,
        style = 'bold'
    },
    left_sep = {
        str = ' ',
        hl = {
            fg = colors.fg3,
            bg = colors.bg3,
        }
    },
    right_sep = {
        str = ' ',
        hl = {
            fg = colors.fg3,
            bg = colors.bg3,
        }
    }
}


require('feline').setup({
    theme = colors,
    components = components,
    default_bg = colors.bg3,
    default_fg = colors.fg3,
    vi_mode_colors = vi_mode_colors,
    --    force_inactive = force_inactive,
})
