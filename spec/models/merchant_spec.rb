require 'rails_helper'

RSpec.describe Merchant do
  describe 'relationships' do
    it { should have_many(:items) }
  end

  describe 'class methods' do
    it '.find_by_name' do
      merchant1 = create(:merchant, name: 'Pilson & Sons')
      merchant2 = create(:merchant, name: 'Joe Schlick HVAC')
      merchant3 = create(:merchant, name: 'Willies Big Rigs')
      merchant4 = create(:merchant, name: 'Porky Bob')

      expect(Merchant.find_by_name('p')).to eq [merchant1]
      expect(Merchant.find_by_name('po')).to eq [merchant4]
      expect(Merchant.find_by_name('w')).to eq [merchant3]
      expect(Merchant.find_by_name('J')).to eq [merchant2]
      expect(Merchant.find_by_name('hvac')).to eq [merchant2]
      expect(Merchant.find_by_name('s')).to eq [merchant2]
    end
  end
end
