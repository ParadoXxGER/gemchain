require 'gemchain/block'

class Contract < Block
  @@storage_path = './data/'
  @@block_suffix = '.contract'
end