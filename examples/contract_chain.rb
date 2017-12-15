require 'gemchain/blockchain'
require_relative 'contract'

class ContractChain < Blockchain
  @@block_class = Contract
  @@storage_path = ''
end
