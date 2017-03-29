require 'rails_helper'

RSpec.describe Family do
  subject { build(:family) }

  it { is_expected.to be_valid }
  it_behaves_like 'a named model', :family_name

  describe '.auto_merge!' do
    it 'merges many families together by name' do
      create_list(:family, 3, name: 'Alpha')
      create_list(:family, 2, name: 'Beta')
      create_list(:family, 1, name: 'Gamma')

      Family.auto_merge!
      expect(Family.order(:name).pluck(:name)).to eq ['Alpha', 'Beta', 'Gamma']
    end

    it 'merges people within the families' do
      families = create_list(:family, 3, name: 'Alpha')
      create(:person, first_name: 'Brian', last_name: 'Houston').join(families[0])
      create(:person, first_name: 'Billy', last_name: 'Graham' ).join(families[0])
      create(:person, first_name: 'Billy', last_name: 'Graham' ).join(families[1])
      create(:person, first_name: 'Billy', last_name: 'Graham' ).join(families[2])
      create(:person, first_name: 'Derek', last_name: 'Johnson').join(families[2])

      Family.auto_merge!
      expect(Family.count).to eq 1
      expect(Person.count).to eq 3
      expect(Person.order(:first_name).pluck(:first_name)).to eq ['Billy', 'Brian', 'Derek']
    end
  end
end
