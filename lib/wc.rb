# frozen_string_literal: true

require_relative 'shared/cli_utils'
require_relative 'configs/wc_config'

module WcTool
  def self.parse_options(argv)
    options = { lines: false, words: false, chars: false, bytes: false }
    banner = 'Usage: wc_tool.rb [options] filename'
    CLIUtils.parse_options(argv, options, WC_OPTION_DEFS, banner: banner)
  end

  def self.process_input(content, filename)
    text = content.respond_to?(:read) ? content.read : content
    text.force_encoding('BINARY')

    {
      lines: text.lines.count,
      words: text.split(/\s+/).count { |element| !element.empty? },
      chars: text.chars.count,
      bytes: text.bytesize,
      filename: filename
    }
  end

  def self.default_output(result)
    [result[:lines], result[:words], result[:bytes], result[:filename]]
  end

  def self.selective_output(result, options)
    [].tap do |out|
      out << result[:lines] if options[:lines]
      out << result[:words] if options[:words]
      out << result[:chars] if options[:chars]
      out << result[:bytes] if options[:bytes]
      out << result[:filename]
    end
  end

  def self.print_output(result, options)
    output = if options.values.none?
               default_output(result)
             else
               selective_output(
                 result, options
               )
             end
    puts output.join(options.values.none? ? "\t" : ' ')
  end

  def self.run_cli(argv)
    options, args = parse_options(argv)
    filename = args[0]

    if filename && File.exist?(filename)
      file = File.open(filename, 'r')
    elsif !$stdin.tty?
      file = $stdin
      filename = nil
    else
      puts "File not found: #{filename}"
      exit 1
    end

    result = process_input(file, filename)
    file.close unless file == $stdin

    print_output(result, options)
  end
end
