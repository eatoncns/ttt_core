require 'ttt_core/game'
require 'ttt_core/board'

module TttCore
  RSpec.describe Game do
    before(:each) do
      @board = Board.new
      @player_one = double("player_one", {:mark => "X", :choose_space => random_space(@board)})
      @player_two = double("player_two", {:mark => "O", :choose_space => random_space(@board)})
      @game = Game.new(@board, @player_one, @player_two)
    end

    describe "#take_turn" do
      context "when called for first time" do
        it "has player one choose space on board" do
          expect(@player_one).to receive(:choose_space).with(@board)
          @game.take_turn()
        end
      end

      context "when called multiple times" do
        it "alternates between players" do
          expect(@player_one).to receive(:choose_space).ordered
          expect(@player_two).to receive(:choose_space).ordered
          expect(@player_one).to receive(:choose_space).ordered
          expect(@player_two).to receive(:choose_space).ordered

          4.times { @game.take_turn() }
        end
      end

      it "sets mark in chosen space on board" do
        space = random_space(@board)
        allow(@player_one).to receive(:choose_space).and_return(space)
        @game.take_turn()
        expect(@board.get_mark(space)).to eq @player_one.mark
      end
    end

    describe "#player_chooses" do
      let(:space) { 1 }

      it "sets mark in chosen space on board" do
        @game.player_chooses(space)
        expect(@board.get_mark(space)).to eq @player_one.mark
      end

      it "switches players" do
        @game.player_chooses(space)
        expect(@game.current_player).to be @player_two
      end
    end

    describe "#over?" do
      context "when board is not in game over state" do
        it "returns false" do
          expect(@game.over?).to be false
        end
      end

      context "when board is in game over state" do
        it "returns true" do
          board = Board.from_a(["X", "X", "O",
                                "O" ,"O", "X",
                                "X", "X", "O"])
          @game = Game.new(board, @player_one, @player_two)
          expect(@game.over?).to be true
        end
      end
    end
  end
end
