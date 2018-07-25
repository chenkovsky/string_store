require "string_pool"

class StringPool
  include Enumerable(String)

  def [](hash : UInt64) : String
    ret = self[hash]?
    raise IndexError.new if ret.nil?
    return ret
  end

  def []?(hash : UInt64) : String?
    mask = (@capacity - 1).to_u64
    index = hash & mask
    next_probe_offset = 1_u64
    while (h = @hashes[index]) != 0
      if h == hash
        return @values[index]
      end
      index = (index + next_probe_offset) & mask
      next_probe_offset += 1_u64
    end
    return nil
  end

  def get_id(str : String)
    get_id(str.to_unsafe, str.bytesize)
  end

  def get_id(str : IO::Memory)
    get_id(str.buffer, str.bytesize)
  end

  def each
    @capacity.times do |i|
      yield @values[i] if @hashes[i] != 0
    end
  end

  def get_id(str : UInt8*, len) : UInt64
    hash = hash(str, len)
    get(hash, str, len)
    return hash
  end
end
