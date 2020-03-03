require 'rails_helper'

describe Discount, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :percent }
    it { should validate_presence_of :item_count }
  end

  describe "relationships" do
    it {should belong_to :merchant}
  end
end
