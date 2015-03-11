RSpec.describe SearchForm do
  it 'upcases the postcode before validation' do
    VCR.use_cassette(:rg2_1aa) do
      described_class.new(postcode: 'rg2 1aa').tap do |search|
        search.validate

        expect(search.postcode).to eql('RG2 1AA')
      end
    end
  end

  describe 'validation' do
    it 'is valid with valid attributes' do
      VCR.use_cassette(:rg2_1aa) do
        expect(described_class.new(postcode: 'RG2 1AA')).to be_valid
      end
    end

    it 'requires a postcode' do
      expect(described_class.new).to_not be_valid
    end

    it 'requires a correctly formatted postcode' do
      expect(described_class.new(postcode: 'ABC')).to_not be_valid
    end

    it 'requires a geocoded postcode' do
      allow(Geocode).to receive(:call).and_return(false)

      expect(described_class.new(postcode: 'ZZ1 1ZZ')).to_not be_valid
    end
  end

  describe '#pension_pot?' do
    let(:form) { described_class.new(pension_pot: pension_pot) }

    subject(:pension_pot?) { form.pension_pot? }

    context 'when the value for `pension_pot` is 1' do
      let(:pension_pot) { '1' }

      it { is_expected.to be_truthy }
    end

    context 'when the value for `pension_pot` is an empty string' do
      let(:pension_pot) { '' }

      it { is_expected.to be_falsey }
    end
  end

  describe '#to_query' do
    let(:serializer) { double }

    before do
      allow(Geocode).to receive(:call).and_return(true)
      allow(SearchFormSerializer).to receive(:new).and_return(serializer)
    end

    subject { described_class.new(postcode: 'ABC 123') }

    it 'builds the query JSON via the `SearchFormSerializer`' do
      expect(serializer).to receive(:as_json)

      subject.to_query
    end
  end
end
