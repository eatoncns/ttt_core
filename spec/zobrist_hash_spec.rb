require 'ttt_core/zobrist_hash'

module TttCore
  RSpec.describe ZobristHash do
    let(:bit_strings) { (1..32).to_a }
    let(:zobrist_hash) { ZobristHash.new(bit_strings) }

    it "initially returns 0" do
      expect(zobrist_hash.get()).to eq 0
    end

    it "updates hash based on bitstrings" do
      zobrist_hash.update(1, "X")
      zobrist_hash.update(9, "X")
      # 01 ^ 11 = 10
      expect(zobrist_hash.get()).to eq 8
    end

    it "updates using different bitstrings for each mark" do
      zobrist_hash.update(1, "O")
      expect(zobrist_hash.get()).to eq 17
    end

    it "reverses an update when applied again" do
      zobrist_hash.update(1, "X")
      zobrist_hash.update(9, "X")
      zobrist_hash.update(1, "X")
      expect(zobrist_hash.get()).to eq 9
    end
  end
end
