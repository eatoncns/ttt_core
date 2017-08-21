require 'ttt_core/computer'
require 'ttt_core/board'
require 'ttt_core/game'

module TttCore
  RSpec.describe Computer do
    let(:computer) { Computer.new("X") }

    describe "#choose_space" do
      it "chooses winning space when possible" do
        board = Board.from_a(["X", "", "X",
                              "O", "", "",
                              "O", "", ""])
        expect(computer.choose_space(board)).to eq 2
      end

      it "blocks opponent win" do
        board = Board.from_a(["O", "X", "X",
                              "O", "", "",
                              "", "", ""])
        expect(computer.choose_space(board)).to eq 7
      end

      it "blocks a fork" do
        board = Board.from_a(["O", "", "",
                              "", "X", "",
                              "", "", "O"])
        expect(computer.choose_space(board)).to satisfy("be an edge space") { |space| space.even? }
      end

      it "creates fork" do
        board = Board.from_a(["O", "", "",
                              "", "X", "",
                              "", "O", "X"])
        expect(computer.choose_space(board)).to eq 3 
      end
    end

    describe "full game" do
      let(:other_computer) { Computer.new("O") }

      [3, 4].each do |dimension|
        context "when computer is playing computer with board dimension #{dimension}" do
          it "ends in draw" do
            board = Board.new(dimension)
            Game.play(board, computer, other_computer)
            expect(board.drawn?).to be true 
          end 
        end
      end
    end
  end
end
