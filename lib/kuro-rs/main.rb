module KuroRs
  def KuroRs.open(device_name)
    KuroRs.new(device_name)
  end
  
  class Error < Exception
  end
  
  class KuroRs
    attr_accessor :verbose

    def busy? 
      @busy
    end

    def serialport
      @sp
    end

    def initialize(device_name)
      @device_name = device_name
      @verbose = false
      @busy = false
      if !File.exists? device_name.to_s
        device_name = "nil" if device_name.to_s.size < 1
        raise Error.new "device not found (#{device_name})"
      end
      @sp = SerialPort.new(device_name, 115200, 8, 1, 0)
    end

    def close
      @sp.close
    end
    
    def read
      @busy = true
      begin
        ## request reading mode
        @sp.write 'c'
        @sp.write 'r'
        puts 'read mode' if @verbose
        raise Error.new 'response is not "Y"' unless @sp.getc.chr == 'Y'
        timeout(15) do
          while @sp.getc.chr != 'S' do end
        end

        ## read data
        puts 'reading data..' if @verbose
        data = (0...240).to_a.map{|i| @sp.getc} # read 240 Bytes
        raise Error.new 'response is not "E"' unless @sp.getc.chr == 'E'
      rescue Error, StandardError => e
        @busy = false
        raise Error.new e
      rescue Timeout::Error
        @busy = false
        raise Error.new 'no response'
      end
      
      ## hex dump
      hex_str = data.map{|i|
        h = i.to_s(16)
        h = "0#{h}" if h.size < 2
        h
      }.join('')
      @busy = false
      return hex_str
    end
    
    def write(hex_str)
      @busy = true
      ## request writing mode
      begin
        @sp.write 'c'
        @sp.write 't'
        raise Error.new 'response is not "Y"' unless @sp.getc.chr == 'Y'
        @sp.write '1'
        raise Error.new 'response is not "Y"' unless @sp.getc.chr == 'Y'
      rescue Error, StandardError => e
        @busy = false
        raise Error.new e
      end

      ## write hex string
      cmd_arr = []
      arr = hex_str.split('')
      loop do
        s = arr.shift + arr.shift
        cmd_arr << s.hex
        break if arr.empty?
      end
      
      puts "command size:#{cmd_arr.size}(Bytes)" if @verbose
      puts 'writing data...' if @verbose
      begin
        cmd_arr.each{|c|
          @sp.putc c
        }
        raise Error.new 'response is not E' unless @sp.getc.chr == 'E'
        @busy = false
      rescue => e
        @busy = false
        raise Error.new e
      end
    end
    
  end
  
end
