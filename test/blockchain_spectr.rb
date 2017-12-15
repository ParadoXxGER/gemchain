require_relative '../lib/block'
require_relative '../lib/blockchain'
require 'byebug'
require 'date'

class KittyBlock < Block
end

class KittyBlockchain < Blockchain
  @@block_class = KittyBlock
end


Spectr.new.test 'Test the kitty blockchain' do |test|

  kbc = KittyBlockchain.new()

  kbc.create_index(0, 'KittyBlockchain', 0)

  test.assume('KittyBlockchain has one KittyBlock', true) do
    kbc.block_index[0].is_a?(KittyBlock)
  end

end

class DoggyBlock < Block
end

class DoggyBlockchain < Blockchain
  @@block_class = DoggyBlock
end


Spectr.new.test 'Test the doggy blockchain' do |test|

  dbc = DoggyBlockchain.new()

  dbc.create_index(0, 'DoggyBlockchain', 0)

  test.assume('DoggyBlockchain has one DoggyBlock', true) do
    dbc.block_index[0].is_a?(DoggyBlock)
  end

  test.assume('DoggyBlockchain block is not a kittyblock', false) do
    dbc.block_index[0].is_a?(KittyBlock)
  end

  test.assume('DoggyBlockchain integrity is valid', true) do
    dbc.transaction Date.new.to_s
    dbc.valid?
  end

end