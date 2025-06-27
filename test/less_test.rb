# frozen_string_literal: true

require 'minitest/autorun'
require 'stringio'
require_relative '../lib/less'

describe 'Less command - parse options' do
  it 'should pase -N option' do
    args = ['-N', 'test.txt']
    options, _filenames = LessTool.parse_options(args)
    _(options[:line_numbers]).must_equal true
    _(args.last).must_equal 'test.txt'
  end

  it 'should parse -F option' do
    args = ['-F', 'test.txt']
    options, _filenames = LessTool.parse_options(args)
    _(options[:quit_if_one_screen]).must_equal true
    _(args.last).must_equal 'test.txt'
  end

  it 'should parse -X option' do
    args = ['-X', 'test.txt']
    options, _filenames = LessTool.parse_options(args)
    _(options[:no_init]).must_equal true
    _(args.last).must_equal 'test.txt'
  end
end

describe 'Less command - run_cli' do
  before do 
    @content = "Line 1\nLine 2\nLine 3"
    File.write('test.txt', @content)
  end

  after do
    File.delete('test.txt') if File.exist?('test.txt')
  end

  it 'should print content with line numbers' do
    output = StringIO.new
    $stdout = output

    LessTool.run_cli(['-N', 'test.txt'])

    expected_output = "\t1: Line 1\n\t2: Line 2\n\t3: Line 3\n"
    _(output.string).must_equal expected_output

    $stdout = STDOUT
  end
end
