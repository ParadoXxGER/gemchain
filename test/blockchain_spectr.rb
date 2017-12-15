require_relative '../lib/block'

class KittyBlock < Block
end

Spectr.new.test 'Test the blockchain' do

  kb0 = KittyBlock.new(0, 'Helllo', 0)


end