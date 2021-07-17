local gl = require 'galaxyline'
local condition = require 'galaxyline.condition'
local gls = gl.section

local colors = {
    bg = '#282c34',
    fg = '#abb2bf',
    section_bg = '#38393f',
    blue = '#61afef',
    green = '#98c379',
    purple = '#c678dd',
    orange = '#e5c07b',
    red = '#e06c75',
    yellow = '#e5c07b',
    darkgrey = '#2c323d',
    middlegrey = '#8791A5',
}

-- Local helper functions
local mode_color = function()
  local mode_colors = {
    n = colors.green,
    i = colors.blue,
    c = colors.orange,
    V = colors.purple,
    [''] = colors.purple,
    v = colors.purple,
    R = colors.red,
  }

  local color = mode_colors[vim.fn.mode()]

  if color == nil then
    color = colors.red
  end

  return color
end


-- Left side
gls.left[1] = {
  ViMode = {
    provider = function()
      local alias = {
        n = 'NORMAL',
        i = 'INSERT',
        c = 'COMMAND',
        V = 'VISUAL',
        [''] = 'VISUAL',
        v = 'VISUAL',
        R = 'REPLACE',
      }
      vim.api.nvim_command('hi GalaxyViMode gui=bold guibg='..mode_color())
      local alias_mode = alias[vim.fn.mode()]
      if alias_mode == nil then
        alias_mode = vim.fn.mode()
      end
      return '  '..alias_mode..' '
    end,
    highlight = { colors.darkgrey, colors.bg , 'bold' },
  },
}

gls.left[2] = {
    FileIcon = {
        provider = { function()
            return '  '
        end, 'FileIcon' },
        highlight = {
            require('galaxyline.provider_fileinfo').get_file_icon,
            colors.section_bg,
        },
    },
}
gls.left[3] = {
    FileName = {
        provider = 'FileName',
        highlight = { colors.fg, colors.section_bg },
        separator = '',
        separator_highlight = { colors.section_bg, colors.bg },
    },
}

gls.left[4] = {
  DiagnosticError = {
    provider = 'DiagnosticError',
    icon = '  ',
    highlight = {colors.red,colors.bg}
  }
}

gls.left[5] = {
  DiagnosticWarn = {
    provider = 'DiagnosticWarn',
    icon = '  ',
    highlight = {colors.yellow,colors.bg},
  }
}

-- Right side

gls.right[1] = {
    DiffAdd = {
        provider = 'DiffAdd',
        icon = '+',
        highlight = { colors.green, colors.bg },
        separator = ' ',
        separator_highlight = { colors.section_bg, colors.bg },
    },
}
gls.right[2] = {
    DiffModified = {
        provider = 'DiffModified',
        icon = '~',
        highlight = { colors.orange, colors.bg },
    },
}
gls.right[3] = {
    DiffRemove = {
        provider = 'DiffRemove',
        icon = '-',
        highlight = { colors.red, colors.bg },
    },
}
gls.right[4] = {
    Space = {
        provider = function()
            return ' '
        end,
        highlight = { colors.section_bg, colors.bg },
    },
}
gls.right[5] = {
    GitBranch = {
        provider = {
            function()
                return '  '
            end,
            'GitBranch',
        },
        condition = condition.check_git_workspace,
        highlight = { colors.middlegrey, colors.bg },
    },
}

gls.right[6] = {
  FileFormat = {
    provider = 'FileFormat',
    separator = ' | ',
    separator_highlight = { colors.middlegrey, colors.bg },
    highlight = { colors.fg, colors.bg },
  }
}

gls.right[7] = {
  LineColumn = {
    provider = 'LineColumn',
    separator = ' ',
    separator_highlight = { colors.middlegrey, colors.bg },
    highlight = { colors.fg, colors.bg },
  }
}

gls.right[8] = {
    LinePercent = {
        provider = 'LinePercent',
        separator = '',
        separator_highlight = { colors.blue, colors.bg },
        highlight = { colors.darkgrey, colors.blue },
    },
}


gls.short_line_left[1] = {
  BufferType = {
    provider = 'FileTypeName',
    separator = '',
    separator_highlight = {colors.purple,colors.bg},
    highlight = {colors.bg,colors.purple}
  }
}

gls.short_line_right[1] = {
  BufferIcon = {
    provider= 'BufferIcon',
    separator = '',
    separator_highlight = {colors.purple,colors.bg},
    highlight = {colors.bg,colors.purple}
  }
}
