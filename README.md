# Gemchain

## build cool things on the gemchain.

Getting started:


Define your Block. In this case a Contract

``` ruby
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
```

Also for your Contract, you need a ContractChain:

``` ruby
require_relative 'contract'

class ContractChain < Blockchain
  @@block_class = Contract
  @@storage_path = './data'
end
```

Lets start creating a contract Chain:

``` ruby
require_relative 'contract_chain'

my_contract_chain = ContractChain.new
my_contract_chain.create_index(0, 'ContractChain', 0)

# Now you can add transactions, which will rollback if there is a error

my_data = MyData.new ("key", "value", "key1", "value2")

my_contract_chain.transaction mydata
```