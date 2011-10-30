#!/usr/bin/env ruby
require 'rubygems'
#require 'kuro-rs'
require File.dirname(__FILE__)+'/../lib/kuro-rs'

if ARGV.size < 2
  puts '!!Device Name and Hex String required'
  puts 'e.g.  ruby write.rb /dev/tty.usbserial-0012a3b4 ffffffff0300f0e0018083...'
  exit 1
end

device_name = ARGV.shift
hex_str = ARGV.shift

begin
  kr = KuroRs.open device_name
rescue KuroRs::Error, StandardError => e
  STDERR.puts e
  exit 1
end

kr.verbose = true
kr.write hex_str
