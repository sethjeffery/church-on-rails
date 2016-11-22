RSpec.shared_examples "a named model" do |name_field = :name|
  it 'returns name from #to_s' do
    expect(subject.to_s).to eq subject.send(name_field).to_s
  end
end
