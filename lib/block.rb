require 'digest' # for hash checksum digest function SHA256
require 'json'
require 'fileutils'

class Block
  attr_reader :index
  attr_reader :timestamp
  attr_reader :data
  attr_reader :previous_hash
  attr_reader :hash
  attr_reader :storage_path
  attr_reader :block_suffix
  attr_reader :digest

  @@storage_path = './data/'
  @@block_suffix = '.block'
  @@digest = Digest::SHA512

  def initialize(index, data, previous_hash)
    raise NotImplementedError, "ERROR: You need to implement a to_json method on #{data.class}" unless data.respond_to?(:to_json)
    @index         = index
    @timestamp     = Time.now
    @data          = data
    @previous_hash = previous_hash
    @hash          = calc_hash
    @storage_path = @@storage_path
    @block_suffix = @@block_suffix
    @digest = @@digest
  end

  def save
    File.write("#{@@storage_path}#{hash}#{@@block_suffix}", {
        index: @index,
        timestamp: @timestamp,
        data: @data.to_json,
        previous_hash: @previous_hash,
        hash: @hash
    }.to_json)
  rescue IOError => e
    puts "FATAL: Could not save blocks on the blockchain #{e}"
  end

  private

  def calc_hash
    sha = @@digest.new
    sha.update(@index.to_s + @timestamp.to_s + @data.to_s + @previous_hash.to_s)
    sha.hexdigest
  end
end
