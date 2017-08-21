require_relative 'mark'
require_relative 'board'

module TttCore
  class Negamax
    private_class_method :new

    MAX_VALUE = 100
    VALUE_BOUND = MAX_VALUE + 1

    def self.value_to_mark(mark, board, transposition_table)
      negamax = new(board, transposition_table)
      negamax.value_to_mark_at(mark, 0, -VALUE_BOUND, VALUE_BOUND)
    end

    def value_to_mark_at(mark, depth, alpha, beta)
      tt_value, tt_alpha, tt_beta = transposition_lookup(depth, alpha, beta)
      if !tt_value.nil?
        return tt_value
      end
      if @board.game_over?
        terminal_value(mark, depth)
      else
        max_next_move_value(mark, depth, alpha, tt_alpha, tt_beta)
      end
    end

    def initialize(board, transposition_table)
      @board = board
      @transposition_table = transposition_table
    end

    private
      def transposition_lookup(depth, alpha, beta)
        if @transposition_table.has_key?(@board.state_hash())
          return @transposition_table.parameters_for(@board.state_hash(), depth, alpha, beta)
        end
        [nil, alpha, beta]
      end

      def terminal_value(mark, depth)
        if @board.drawn?
          return 0
        end
        winning_mark = @board.winning_mark()
        if winning_mark == mark
          return MAX_VALUE - depth
        end
        -MAX_VALUE + depth
      end

      def max_next_move_value(mark, depth, orig_alpha, alpha, beta)
        max_value = -VALUE_BOUND
        @board.empty_spaces.each do |space|
          move_value = value_of_move(mark, space, depth, alpha, beta)
          max_value = [max_value, move_value].max
          alpha = [alpha, move_value].max
          if alpha >= beta
            break
          end
        end
        store_transposition_entry(max_value, orig_alpha, beta, depth)
        max_value
      end

      def value_of_move(mark, space, depth, alpha, beta)
        Board.with_move(@board, space, mark) do
          -value_to_mark_at(Mark.opponent(mark), depth+1, -beta, -alpha)   
        end
      end

      def store_transposition_entry(value, orig_alpha, beta, depth)
        @transposition_table.store_entry(@board.state_hash(), value, orig_alpha, beta, depth)
      end
  end
end
