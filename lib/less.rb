# frozen_string_literal: true

require_relative 'shared/cli_utils'
require_relative 'configs/less_config'
require 'io/console'

module LessTool
  def self.parse_options(args)
    options = { line_numbers: false, chop_long_lines: false, quit_if_one_screen: false, no_init: false }

    banner = 'Usage: ./bin/less [options] filename...'
    CLIUtils.parse_options(args, options, LessConfig::LESS_OPTION_DEFS, banner: banner)
  end

  def self.msg_for_args(args)
    return unless args.empty?

    puts 'Error: No input files or arguments provided.'
    puts 'Usage: ./bin/less [options] [file ...]'
    puts "Try './bin/less --help' for more information."
    exit 1
  end

  def self.paginate_content(content)

    lines = content.lines
    row = IO.console.winsize[0] - 1 # Subtract 1 for the prompt line
    i = 0
    while i < lines.size
      system('clear')
      puts lines[i, row]
      puts "\n--More-- (q to quit)"
      input = STDIN.getch
      break if input == 'q' || input == 'Q'
      i += row
    end
  end
  
  def self.run_cli(argv, test_mode: false)
    options, args = parse_options(argv)
    msg_for_args(args)

    filenames = args

    CLIUtils.each_input_file(filenames) do |content, _filename|
      if options[:line_numbers]
        content.lines.each_with_index do |line, index|
          puts "\t#{index + 1}: #{line.chomp}"
        end
      else
        puts content
      end
    end
  end
end
