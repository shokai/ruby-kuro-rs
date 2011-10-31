$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

gem 'serialport','>=1.0.4'
require 'serialport'
require 'timeout'

Dir.glob(File.dirname(__FILE__)+'/kuro-rs/*.rb').each do |f|
  require f
end

module KuroRs
  VERSION = '0.0.6'
end
