require 'gemchain/block'
require 'digest'

class MyData < Hash
  require 'json'
end

class Contract < Block
  @@storage_path = './data/'
  @@block_suffix = '.contract'
  @@digest = Digest::SHA256
end