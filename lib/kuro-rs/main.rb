module KuroRs
  def KuroRs.open(device_name)
    KuroRs.new(device_name)
  end

  class Error < Exception
  end
  
  class KuroRs
    attr_accessor :verbose

    def initialize(device_name)
      @device_name = device_name
      @verbose = false

      if !File.exists? device_name.to_s
        device_name = "nil" if device_name.to_s.size < 1
        raise Error.new "device not found (#{device_name})"
      end
      @sp = SerialPort.new(device_name, 115200, 8, 1, 0)
    end
    
    def read
      ## request reading mode
      @sp.write 'c'
      @sp.write 'r'
      puts 'read mode' if @verbose
      raise Error.new 'response is not "Y"' unless @sp.getc.chr == 'Y'
      begin
        timeout(5) do
          while @sp.getc.chr != 'S' do end
        end
      rescue StandardError => e
        raise Error.new(e)
      rescue Timeout::Error
        raise Error.new 'no response'
      end
      
      ## read data
      puts 'reading data..' if @verbose
      data = Array.new
      240.times do
        data << @sp.getc
      end
      
      raise Error.new 'response is not "E"' unless @sp.getc.chr == 'E'
      return data.map{|i|
        h = i.to_s(16)
        h = "0#{h}" if h.size < 2
        h
      }.join('')
    end
    
    def write(hex_str)
      ## request writing mode
      @sp.write 'c'
      @sp.write 't'
      raise Error.new 'response is not "Y"' unless @sp.getc.chr == 'Y'
      @sp.write '1'
      raise Error.new 'response is not "Y"' unless @sp.getc.chr == 'Y'
      
      ## write hex string
      cmd_arr = []
      arr = cmd_hex.split('')
      loop do
        s = arr.shift + arr.shift
        cmd_arr << s.hex
        break if arr.empty?
      end
      
      puts "command size:#{cmd_arr.size}(bytes)" if @verbose
      puts 'writing data...' if @verbose
      cmd_arr.each{|c|
        @sp.putc c
      }
      raise Error.new 'response is not E' unless @sp.getc.chr == 'E'
    end
    
  end
  
end
