#!/usr/bin/env ruby
## hex dumpされたデータをKURO-RSの赤外線LEDから発射する
require 'rubygems'
gem 'serialport','>=1.0.4'
require 'serialport'

if ARGV.size < 2
  puts 'e.g.  ruby kuro-rs-write.rb /dev/tty.kuro-rs-port "ffffffff0f00e0c10380070f1f1e3c7c78f0f0e1c1c307000f1f1e3c7"'
  exit 1
end

serial_device = ARGV.shift
cmd_hex = ARGV.shift
raise "command size error (#{cmd_hex.size})" if cmd_hex.size != 240*2

begin
  sp = SerialPort.new(serial_device, 115200, 8, 1, 0)
rescue => e
  STDERR.puts 'cannot open serialport'
  STDERR.puts e
  exit 1
end

sp.write 'c'

sp.write 't'
sp.getc.chr == 'Y' or raise 'not Y'
sp.write '1'
sp.getc.chr == 'Y' or raise 'not Y'

cmd_arr = []
arr = cmd_hex.split('')
loop do
  s = arr.shift
  s += arr.shift
  cmd_arr << s.hex
  break if arr.empty?
end

puts "command size:#{cmd_arr.size}(bytes)"
puts 'writing data...'
cmd_arr.each{|c|
  sp.putc c
}

puts 'waiting response..'

sp.getc.chr == 'E' or raise 'not E'
puts 'success!'
