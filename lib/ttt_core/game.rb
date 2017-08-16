module TttCore
  class Game
    attr_reader :board
    attr_reader :current_player

    def self.play(board, player_one, player_two)
      game = new(board, player_one, player_two)
      until game.over?
        game.take_turn()
      end
    end

    def initialize(board, player_one, player_two)
      @board = board
      @current_player = player_one
      @next_player = player_two
    end

    def take_turn
      space = @current_player.choose_space(@board)
      player_chooses(space)
    end

    def player_chooses(space)
      @board.set_mark(space, @current_player.mark)
      @current_player, @next_player = @next_player, @current_player
    end

    def over?
      @board.game_over?
    end
  end
end
