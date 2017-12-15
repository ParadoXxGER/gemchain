require 'fileutils'
require 'json'

require_relative 'block'
require_relative 'chain_integrity_error'
require_relative 'duplicate_index_error'
require_relative 'no_index_error'

class Blockchain
  attr_reader :block_index

  @@block_class = Block
  @@storage_path = './data/'

  def initialize()
    @block_index = []
  end

  def create_index(index, name, previous_hash)
    raise DuplicateIndexError, 'ERROR: Index is already created!' unless index_empty?
    @block_index << @@block_class.new(index, name, previous_hash.to_s)
    save_index
  end

  def transaction(data)
    raise NoIndexError, 'ERROR: Please create a index first!' if index_empty?
    block = @@block_class.new(@block_index.last.index + 1, data, @block_index.last.hash)
    if valid?
      block.save
      save_index
    else
      raise ChainIntegrityError "FATAL: Blockchain corrupted on block #{@block_index[block.index - 1].index}"
    end
    @block_index.last
  end

  def valid?
    @block_index.each do |block|
      next if block.index.zero?
      raise ChainIntegrityError unless block.previous_hash.eql? @block_index[block.index - 1].hash
    end
    true
  end

  def save_index(block)
    raise NoIndexError, 'ERROR: Please create a index first!' if index_empty?
    @block_index << block
    File.write("#{@@storage_path}#{@block_index.first.data}.index", @block_index.to_json)
  rescue IOError => e
    puts "FATAL: Could not write index to disk!"
    rollback block
  end

  def rollback(block)
    puts "WARNING: Rolling back block number #{block.index}"
    @block_index.delete(block)
  end

  def index_empty?
    @block_index.empty?
  end

end
