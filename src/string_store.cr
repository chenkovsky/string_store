require "./string_store/*"

# @TODO 如果发现有碰撞，那么采用表格hardcode的方式得到碰撞的hash
# 反正 StringPool hash 最高位都是1. hard code 成最高位是0的就行了

class StringStore < StringPool
  StoreFormat = IO::ByteFormat::LittleEndian

  private def string_array_to_io(string_arr, io, format)
    string_arr.size.to_io io, format
    total_length = 0
    string_arr.each do |s|
      total_length += s.bytesize + 1
      io.print s
      io.write_byte 0_u8
    end
    padding = 4 - total_length % 4
    if padding != 4
      (0...padding).each { |_| 0_u8.to_io io, format }
    end
  end

  private def self.read_utf8_string(io, bytes = Array(UInt8).new)
    bytes.clear
    s = io.read_utf8_byte.not_nil!
    while s != 0
      bytes << s
      s = io.read_utf8_byte.not_nil!
    end
    return String.new(bytes.to_unsafe, bytes.size)
  end

  private def self.string_array_from_io(io, format)
    size = Int32.from_io io, format
    total_length = 0
    bytes = Array(UInt8).new
    arr = (0...size).map do |_|
      s = self.read_utf8_string(io, bytes)
      total_length += bytes.size + 1
      s
    end
    padding = 4 - total_length % 4
    if padding != 4
      (0...padding).each { |_| UInt8.from_io io, format }
    end
    arr
  end

  def to_disk(path : String) : Void
    File.open(path, "wb") do |f|
      to_io f, StoreFormat
    end
  end

  def self.from_disk(path : String) : self
    File.open(path, "rb") do |f|
      self.from_io f, StoreFormat
    end
  end

  def to_io(io : IO, format : IO::ByteFormat)
    self.string_array_to_io self.to_a, io, format
  end

  def self.from_io(io : IO, format : IO::ByteFormat)
    arr = self.string_array_from_io io, format
    store = self.new
    arr.each do |s|
      store.get s
    end
    return store
  end
end
