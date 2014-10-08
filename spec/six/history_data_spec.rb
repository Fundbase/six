RSpec.describe SIX::Price do
  let(:client)       { SIX::Client.new(FakeSIX::UI, FakeSIX::PWD) }
  let(:history_data) { client.hiku_data(FakeSIX::LISTING_ID).history_list.history_data }
  let(:price)        { history_data.first.prices.first }

  describe '#value' do
    it 'has a value' do
      expect(price.value).to eq '12.125'
    end
  end
  
  describe '#type' do
    it 'is a last price' do
      expect(price.type).to eq SIX::Price::LAST_PRICE
    end
  end
end
