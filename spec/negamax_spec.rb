require 'ttt_core/negamax'
require 'ttt_core/board'
require 'ttt_core/transposition_table'

module TttCore
  RSpec.describe Negamax do
    let(:transposition_table) { TranspositionTable.new }

    it "returns maximum value when board is won for mark" do
      board = Board.from_a(["X", "X", "X",
                                     "O", "O", "",
                                     "", "", ""])
      expect(Negamax.value_to_mark("X", board, transposition_table)).to eq Negamax::MAX_VALUE
    end

    it "returns negative of maximum value when board is lost for mark" do
      board = Board.from_a(["X", "X", "X",
                                     "O", "O", "",
                                     "", "", ""])
      expect(Negamax.value_to_mark("O", board, transposition_table)).to eq -Negamax::MAX_VALUE
    end

    it "returns zero when board is drawn" do
      board = Board.from_a(["X", "X", "O",
                                     "O", "X", "X",
                                     "X", "O", "O"])
      expect(Negamax.value_to_mark("X", board, transposition_table)).to eq 0
      expect(Negamax.value_to_mark("O", board, transposition_table)).to eq 0 
    end

    it "subtracts number of marks needed to end game from winning score" do
      board = Board.from_a(["X", "X", "",
                                     "O", "O", "",
                                     "", "", ""])
      expect(Negamax.value_to_mark("X", board, transposition_table)).to eq Negamax::MAX_VALUE - 1
    end

    it "add number of marks needed to end game to losing score" do
      board = Board.from_a(["", "", "O",
                                     "O", "X", "",
                                     "X", "", "X"])
      expect(Negamax.value_to_mark("O", board, transposition_table)).to eq -Negamax::MAX_VALUE + 2
    end
  end
end
