require 'digest' # for hash checksum digest function SHA256
require 'json'
require 'fileutils'

class Block
  attr_reader :index
  attr_reader :timestamp
  attr_reader :data
  attr_reader :previous_hash
  attr_reader :hash

  def initialize(index, data, previous_hash)
    @index         = index
    @timestamp     = Time.now
    @data          = data
    @previous_hash = previous_hash
    @hash          = calc_hash
  end

  def save
    File.write("./data/#{hash}.block", {
      index: @index,
      timestamp: @timestamp,
      data: @data,
      previous_hash: @previous_hash,
      hash: @hash
    }.to_json)
  end

  private

  def calc_hash
    sha = Digest::SHA256.new
    sha.update(@index.to_s + @timestamp.to_s + @data.to_s + @previous_hash.to_s)
    sha.hexdigest
  end
end
