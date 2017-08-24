require 'ttt_core/zobrist_hash'

module TttCore
  class Board
    attr_reader :size
    attr_reader :dimension
    attr_reader :spaces_marked 

    def initialize(dimension = 3) 
      @dimension = dimension
      @size = dimension*dimension
      @board = Array.new(@size, "")
      @state_hash = ZobristHash.with_random_bit_strings()
      @spaces_marked = 0
      @min_spaces_for_win = dimension*2 - 1
    end

    def set_mark(space, mark)
      validate_space(space)
      @state_hash.update(space, mark)
      @spaces_marked += 1
      @board[space-1] = mark
    end

    def remove_mark(space)
      validate_space(space)
      @state_hash.update(space, @board[space-1])
      @spaces_marked -= 1
      @board[space-1] = ""
    end

    def get_mark(space)
      validate_space(space)
      @board[space-1]
    end

    def game_over?
      if @spaces_marked < @min_spaces_for_win
        return false
      end
      winning_line_present? || all_spaces_taken?
    end

    def drawn?
      all_spaces_taken? && !winning_line_present?
    end

    def winning_mark
      winning_line = lines.find { |line| winning_line?(line) }
      if winning_line.nil?
        return nil
      end
      winning_line.first
    end

    def empty_spaces
      (1..@size).select { |space| get_mark(space).empty? }
    end
    
    def state_hash
      @state_hash.get()
    end


    def self.with_move(board, space, mark)
      board.set_mark(space, mark)
      yield
    ensure
      board.remove_mark(space)
    end

    def self.from_a(marks)
      board = Board.new
      marks.each_with_index do |mark, index|
        if !mark.empty?
          space = index + 1
          board.set_mark(space, mark)
        end
      end
      board
    end

    private

      def valid_space(space)
        space >= 1 && space <= @size
      end

      def validate_space(space)
        if !valid_space(space)
          raise(IndexError, "space #{space} out of board bounds: (1..#{@size})")
        end
      end

      def rows
        @board.each_slice(@dimension).to_a
      end

      def columns
        rows.transpose
      end

      def column_from_rows(&col_offset)
        (0..@dimension-1).collect { |row| @board[row*@dimension + col_offset.call(row)] }
      end

      def diagonals
        [] << column_from_rows { |row| row } << column_from_rows { |row| @dimension-1-row }
      end

      def lines
        rows + columns + diagonals
      end

      def winning_line?(line)
        !line.first.empty? && line.all? { |mark| mark == line.first } 
      end

      def winning_line_present?
        lines.any? { |line| winning_line?(line) }
      end

      def all_spaces_taken?
        @spaces_marked == @size 
      end
  end
end
