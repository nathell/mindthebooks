require 'spec_helper'
require 'rails_helper'

describe Card do
  before do 
    @card = Card.new
  end

  describe "number" do
    it "should be invalid" do
      ["", " ", "1", "829612982", "1234567A"].each do |number|
        @card.number = number
        expect(@card).not_to be_valid
      end
    end

    it "should be valid" do
      ["12345678", "01010101"].each do |number| 
        @card.number = number
        expect(@card).to be_valid
      end
    end
  end

end
