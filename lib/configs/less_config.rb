# frozen_string_literal: true

module LessConfig
  LESS_OPTION_DEFS = [
    {
      flags: ['-N', '--LINE-NUMBERS'],
      desc: 'Display line numbers',
      action: ->(opts, _) { opts[:line_numbers] = true }
    },
    {
      flags: ['-F', '--quit-if-one-screen'],
      desc: 'Exit if the entire file fits on one screen',
      action: ->(opts, _) { opts[:quit_if_one_screen] = true }
    },
    {
      flags: ['-X', '--no-init'],
      desc: 'Do not clear the screen before exiting',
      action: ->(opts, _) { opts[:no_init] = true }
    }
  ].freeze
end
