#!/usr/bin/env ruby
## KURO-RSで学習データを16進dumpする
require 'rubygems'
gem 'serialport','>=1.0.4'
require 'serialport'

if ARGV.size < 1
  puts "e.g.  ruby kuro-rs-read.rb /dev/tty.kuro-rs-port"
  exit 1
end

serial_device = ARGV.first

begin
  sp = SerialPort.new(serial_device, 115200, 8, 1, 0)
rescue => e
  STDERR.puts 'cannot open serialport'
  STDERR.puts e
  exit 1
end

sp.write 'c'
sp.write 'r'
sp.getc.chr == 'Y' or raise 'not Y'
puts 'request reading mode'

while sp.getc.chr != 'S' do end

## データ部分を読む
puts 'reading data..'
buf = Array.new
240.times do
  buf << sp.getc
end

sp.getc.chr == 'E' or raise 'not E'

puts hex = buf.map{|i|
  h = i.to_s(16)
  h = "0#{h}" if h.size < 2
  h
}.join
