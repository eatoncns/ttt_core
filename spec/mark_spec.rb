require 'ttt_core/mark'

module TttCore
  RSpec.describe Mark do
    describe "opponent" do
      it "returns O for mark X" do
        expect(Mark.opponent("X")).to eq "O" 
      end

      it "returns X for mark O" do
        expect(Mark.opponent("O")).to eq "X"
      end

      it "raises exception for other values" do
        expect{Mark.opponent("Y")}.to raise_error(ArgumentError) 
      end
    end
  end
end
