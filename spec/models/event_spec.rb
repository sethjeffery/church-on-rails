require 'rails_helper'

RSpec.describe Event do
  subject { build(:event) }

  it { is_expected.to be_valid }
  it_behaves_like 'a named model'
end
