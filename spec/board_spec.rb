require 'ttt_core/board'

module TttCore
  RSpec.describe Board do

    let(:board) { Board.new }
    let(:drawn_board) { Board.from_a ["X", "X", "O",
                                      "O" ,"O", "X",
                                      "X", "X", "O"] }
    let(:in_progress_board) { Board.from_a ["X", "", "O",
                                            "O", "", "",
                                            "X", "", ""] }

    describe "#size" do
      context "with default board" do
        it "is 9" do
          expect(board.size).to eq 9
        end
      end

      context "with dimension 4 board" do
        it "is 16" do
          four_board = Board.new(4)
          expect(four_board.size).to eq 16
        end
      end
    end

    describe "#get_mark" do
      context "with a new board" do
        it "returns empty for all spaces" do
          for space in (1..board.size)
            expect(board.get_mark(space).empty?).to eq true
          end
        end
      end

      context "when #set_mark has been called for space" do
        it "returns the same mark" do
          space = board.random_space
          board.set_mark(space, "X")
          expect(board.get_mark(space)).to eq "X"
        end
      end

      [-3, 0, 10].each do |space|
        context "with invalid space #{space} input" do
          it "raises an IndexError" do
            expect{board.get_mark(space)}.to raise_error(IndexError)
          end
        end
      end
    end

    describe "#set_mark" do
      [-3, 0, 10].each do |space|
        context "with invalid space #{space} input" do
          it "raises an IndexError" do
            expect{board.set_mark(space, "X")}.to raise_error(IndexError)
          end
        end
      end 
    end

    describe "#remove_mark" do
      context "when space is populated" do
        it "removes space" do
          space = board.random_space()
          board.set_mark(space, "X")
          board.remove_mark(space)
          expect(board.get_mark(space).empty?).to be true
        end
      end

      context "when space is empty" do
        it "leaves space empty" do
          space = board.random_space()
          board.remove_mark(space)
          expect(board.get_mark(space).empty?).to be true
        end
      end

      [-3, 0, 10].each do |space|
        context "with invalid space #{space} input" do
          it "raises an IndexError" do
            expect{board.remove_mark(space)}.to raise_error(IndexError)
          end
        end
      end 
    end

    describe "#game_over?" do
      context "with a new board" do
        it "returns false" do
          expect(board.game_over?).to be false
        end
      end

      context "when game is drawn" do
        it "returns true" do
          expect(drawn_board.game_over?).to be true
        end
      end

      context "when game is still in progress" do
        it "returns false" do
          expect(in_progress_board.game_over?).to be false
        end
      end

      [[1, 2, 3], [4, 5, 6], [7, 8, 9],
       [1, 4, 7], [2, 5, 8], [3, 6, 9],
       [1, 5, 9], [3, 5, 7]].each do |line|
         context "when player has taken all of line #{line}" do
           it "returns true" do
             line.each { |space| board.set_mark(space, "X") }
             board.empty_spaces.take(2).each { |space| board.set_mark(space, "O") }
             expect(board.game_over?).to be true
           end
         end
       end
    end

    describe "#get_winning_mark" do
      context "when board has been won by X" do
        it "returns X" do
          board = Board.from_a(["X", "X", "X",
                                "O", "O", "",
                                "", "", ""])
          expect(board.winning_mark).to eq "X"
        end
      end

      context "when board has been won by O" do
        it "returns O" do
          board = Board.from_a(["O", "X", "X",
                                "X", "O", "",
                                "", "", "O"])
          expect(board.winning_mark).to eq "O"
        end
      end

      context "when board is drawn" do
        it "returns nil" do
          expect(drawn_board.winning_mark).to be nil 
        end
      end

      context "when board is in progress" do
        it "returns nil" do
          expect(in_progress_board.winning_mark).to be nil
        end
      end
    end

    describe "#drawn?" do
      context "when board is in progress" do
        it "returns false" do
          expect(in_progress_board.drawn?).to be false
        end
      end

      context "when board is drawn" do
        it "returns true" do
          expect(drawn_board.drawn?).to be true 
        end
      end

      context "when full board has been won" do
        it "returns false" do
          board = Board.from_a(["X", "X", "X",
                                "X", "O", "O",
                                "O", "O", "X"])
          expect(board.drawn?).to eq false
        end
      end
    end

    describe "#empty_spaces" do
      context "with full board" do
        it "returns empty array" do
          expect(drawn_board.empty_spaces).to eq []
        end
      end

      context "with in partially filled board" do
        it "returns empty spaces" do
          board = Board.from_a(["X", "", "O",
                                "", "X", "",
                                "O", "X", ""])
          expect(board.empty_spaces).to eq [2, 4, 6, 9]
        end
      end
    end

    describe "#state_hash" do
      it "returns same value for boards in same state" do
        board_state = ["X", "O", "",
                       "X", "", "",
                       "O", "", "X"]
        board = Board.from_a(board_state)
        other_board = Board.from_a(board_state)
        expect(board.state_hash()).to eq other_board.state_hash()
      end

      it "returns different value for boards in different state" do
        board = Board.from_a(["X", "", "O",
                              "", "X", "",
                              "O", "X", ""])
        other_board = Board.from_a(["X", "", "O",
                                    "", "X", "",
                                    "O", "", ""])
        expect(board.state_hash()).not_to eq other_board.state_hash()
      end

      it "returns same value for boards in same state regardless of how they got there" do
        board = Board.new
        board.set_mark(5, "X")
        board.set_mark(9, "O")

        other_board = Board.new
        other_board.set_mark(6, "X")
        other_board.set_mark(9, "O")
        other_board.set_mark(5, "X")
        other_board.remove_mark(6)
        expect(board.state_hash()).to eq other_board.state_hash()
      end
    end
  end
end
