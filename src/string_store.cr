require "./string_store/*"

# @TODO 如果发现有碰撞，那么采用表格hardcode的方式得到碰撞的hash
# 反正 StringPool hash 最高位都是1. hard code 成最高位是0的就行了
require "super_io"

class StringStore < StringPool
  SuperIO.save_load

  def to_io(io : IO, format : IO::ByteFormat)
    SuperIO.to_io self.to_a, io, format
  end

  def self.from_io(io : IO, format : IO::ByteFormat)
    arr = SuperIO.from_io Array(String), io, format
    store = self.new
    arr.each do |s|
      store.get s
    end
    return store
  end
end
