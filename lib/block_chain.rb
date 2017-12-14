require_relative 'block'

class BlockChain

  attr_reader :blocks
  attr_reader :genesis

  def initialize(index, data, previous_hash)
    @blocks = []
    @blocks << Block.new( index, data, previous_hash.to_s )
    @genesis = @blocks.first
  end

  def add(data)
    @blocks << Block.new( @blocks.last.index + 1, data, @blocks.last.hash)
    @blocks.last
  end

end