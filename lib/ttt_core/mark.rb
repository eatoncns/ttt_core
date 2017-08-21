module TttCore
  module Mark
    def Mark.opponent(mark)
      raise ArgumentError, "Mark #{mark} is not X or O" unless mark == "X" || mark == "O"
      (mark == "X") ? "O" : "X"
    end
  end
end
