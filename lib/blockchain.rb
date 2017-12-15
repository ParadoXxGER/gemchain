require 'fileutils'
require 'json'

require_relative 'block'
require_relative 'chain_integrity_error'
require_relative 'duplicate_index_error'
require_relative 'no_index_error'

class Blockchain
  attr_reader :blocks
  attr_reader :genesis
  attr_reader :block_class

  def initialize(block_class=Block)
    @blocks = []
    @block_class = block_class
  end

  def create_index(index, name, previous_hash)
    raise DuplicateIndexError, 'ERROR: Index is already created!' unless @blocks.empty?
    @blocks << @block_class.new(index, name, previous_hash.to_s)
    @genesis = @blocks.first
    save_index
  end

  def add(data)
    raise NoIndexError, 'ERROR: Please create a index first!' if @blocks.empty?
    block = @block_class.new(@blocks.last.index + 1, data, @blocks.last.hash)
    @blocks << block
    block.save if integrity_given?
    @blocks.last
  end

  def integrity_given?
    @blocks.each do |block|
      next if block.index.zero?
      raise ChainIntegrityError unless block.previous_hash.eql? @blocks[block.index - 1].hash
    end
    true
  end

  def save_index
    raise NoIndexError, 'ERROR: Please create a index first!' if @blocks.empty?
    File.write("./data/#{genesis.data}.index", @blocks.to_json)
  end

  def load_index(name)
    raise DuplicateIndexError, 'ERROR: Index is already created!' unless @blocks.empty?
    bc_index = JSON.parse(File.read("./data/#{name}.index"))
    # Todo verify blockchain integrity!
    BlockChain.new.tap do |bc|
      bc.create_index(bc_index[0].index, bc_index[0].data, bc_index[0].previous_hash)
    end
  end
end
