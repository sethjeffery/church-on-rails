require 'rails_helper'

RSpec.describe Family do
  subject { build(:family) }

  it { is_expected.to be_valid }
  it_behaves_like 'a named model', :family_name
end
