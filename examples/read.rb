#!/usr/bin/env ruby
require 'rubygems'
#require 'kuro-rs'
require File.dirname(__FILE__)+'/../lib/kuro-rs'

if ARGV.size < 1
  puts '!!Device Name required'
  puts 'e.g.  ruby read.rb /dev/tty.usbserial-0012a3b4'
  exit 1
end

device_name = ARGV.shift

begin
  kr = KuroRs.open device_name
rescue KuroRs::Error, StandardError => e
  STDERR.puts e
  exit 1
end

kr.verbose = true
puts kr.read ## => hex dump
