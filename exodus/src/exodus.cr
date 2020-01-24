require "option_parser"
require "zip"

module Exodus

  VERSION = "0.2.3"
  path = ""
  exodus_files=[""]
  
  OptionParser.parse do |parser|
      parser.banner = "Exodus #{VERSION} Usage: package path to binary "
      parser.on("-p NAME", "--path=NAME", "Path to binary") { |name| path = name }
      parser.on("-h", "--help", "Show this help") { puts parser }
  end

  if path != nil

    stdout = IO::Memory.new
    stderr = IO::Memory.new
    status = Process.run("ldd", args: ["#{path}"], output: stdout, error: stderr)
  
    stdout.to_s.strip.split('\n').each do |line|
      line = line.gsub /\t/, ""
      puts line
      if line.includes? "=>"
        exodus_files << line.split("=>")[1].strip.split(' ')[0]
      else
        exodus_files << line.split(' ')[0].strip
      end
    end
  
    exodus_files.delete("linux-vdso.so.1")
    exodus_files.shift
    puts ""
    puts exodus_files

    File.open("./exodus.zip", "w") do |file|
      Zip::Writer.open(file) do |zip|
        zip.add(path, File.open(path))
        exodus_files.each do |compress_me|
          zip.add(compress_me, File.open(compress_me))
        end        
      end
    end

  end

end
