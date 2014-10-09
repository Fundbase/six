RSpec.describe SIX::Client do
  let(:client) { described_class.new(FakeSIX::UI, FakeSIX::PWD) }

  it 're-logins if the session ID is not valid anymore' do
  end

  describe '#initialize' do
    it 'can login' do
      expect(client).to be_a SIX::Client
    end

    it 'raises if credentials are invalid' do
      expect{ described_class.new('CI43937-username', 'pwd') }.to raise_exception(SIX::Error, /invalid user or password/)
    end

    it 'raises if there is no ui or pwd' do
      expect{ described_class.new(nil, FakeSIX::PWD) }.to raise_exception(SIX::Error)
      expect{ described_class.new(FakeSIX::UI, nil) }.to  raise_exception(SIX::Error)
    end
  end

  describe '#hiku_data' do
    let(:history_data) { client.hiku_data(FakeSIX::LISTING_ID).history_list.history_data }

    it 'returns an instrument list' do
      expect(client.hiku_data(FakeSIX::LISTING_ID)).to be_an SIX::Instrument
    end

    it 'contains prices' do
      expect(history_data.first.prices.first).to be_a SIX::Price
    end

    it 'contains proper type of prices' do
      expect(history_data.flat_map(&:prices).map(&:type).uniq).to eq [SIX::Price::LAST_PRICE]
    end

    it 'raises if no identifier provided' do
      expect{ client.hiku_data(nil) }.to raise_exception(SIX::Error, 'Missing mandatory argument')
    end

    it 'has an error if identifier is not valid' do
      expect(client.hiku_data('1396260,363,405').error).to match /Got no HIKU data for listing/
    end
  end

  describe '#identify_instrument' do
    it 'can identify an instrument' do
      expect(client.identify_instrument(FakeSIX::ISIN)).to eq '20209492,9760,814'
    end

    it 'raises if no ISIN provided' do
      expect{ client.identify_instrument(nil) }.to raise_exception(SIX::Error, 'Missing mandatory method\'s argument')
    end

    it 'returns nil for an unknown ISIN' do
      expect(client.identify_instrument('dummy_isin')).to be_nil
    end
  end
end
