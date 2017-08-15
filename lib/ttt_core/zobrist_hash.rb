module TttCore
  class ZobristHash
    FIXNUM_MAX = (2**(0.size * 8 -2) -1)

    @@bit_strings = Array.new(32) { Random.rand(FIXNUM_MAX) }

    def self.with_random_bit_strings
      new(@@bit_strings)
    end

    def initialize(bit_strings)
      @bit_strings = bit_strings
      @mark_index = bit_strings.length / 2
      @hash = 0
    end

    def get
      @hash 
    end

    def update(space, mark)
      @hash = @hash ^ @bit_strings[index_for(space ,mark)]
    end

    private
    def index_for(space, mark)
      mark_modifier = (mark == "X") ? 0 : 1
      mark_modifier*@mark_index + space-1 
    end
  end
end
