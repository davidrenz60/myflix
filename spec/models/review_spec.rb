require 'spec_helper'

describe Review do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_presence_of(:content) }
  it { should validate_presence_of(:rating) }
  it do
    should validate_numericality_of(:rating)
      .is_greater_than_or_equal_to(0)
      .is_less_than_or_equal_to(5)
      .only_integer
  end
end
