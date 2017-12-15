require 'spectr'
require 'byebug'
require 'digest'
require_relative '../lib/block'

Spectr.new.test 'Test a crypto block' do |test|
  b0 = Block.new(0, 'Hello World', 0)
  b1 = Block.new(b0.index + 1, 'My Data', b0.hash)
  b2 = Block.new(b1.index + 1, 'Hashycorp', b1.hash)
  b3 = Block.new(b2.index + 1, 'Integrity check!', b2.hash)

  test.assume('Block b0 is initialized correctly', true) do
    b0.is_a?(Block)
  end

  test.assume('Block b1 is initialized correctly', true) do
    b1.is_a?(Block)
  end

  test.assume('Block b2 is initialized correctly', true) do
    b2.is_a?(Block)
  end

  test.assume('Block b3 is initialized correctly', true) do
    b3.is_a?(Block)
  end

  test.assume('Block b0 is the genesis block', true) do
    b0.index.zero?
  end

  test.assume('Block b1 previous hash is the hash of b0', b0.hash) do
    b1.previous_hash
  end

  # Fake block
  fake_b2 = Block.new(b1.index + 1, 'THIS HAS CHANGED', b1.hash)

  test.assume('Block b3 has a wrong previous hash if b2 is fake', false) do
    b3.previous_hash.eql? fake_b2.hash
  end

  test.assume('Block b3 has a correct previous has if b2 is also correct', true) do
    b3.previous_hash.eql? b2.hash
  end

  test.assume('The Block has a SHA512 Digest', Digest::SHA512) do
    b0.digest
  end

  test.assume('The Block has ./data/ as storage path', './data/') do
    b0.storage_path
  end

  test.assume('The Block has .block suffix', '.block') do
    b0.block_suffix
  end
end
