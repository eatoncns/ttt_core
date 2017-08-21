module TttCore
  class TranspositionTable

    TranspositionEntry = Struct.new(:type, :value, :depth)

    def initialize
      @table = {}
    end

    def has_key?(key)
      @table.has_key?(key)
    end

    def parameters_for(key, depth, alpha, beta)
      raise ArgumentError if !has_key?(key)
      entry = @table[key]
      value = entry.value + (depth - entry.depth)
      return parameters_for_entry(entry, value, alpha, beta)
    end

    def store_entry(key, value, orig_alpha, beta, depth)
      entry = TranspositionEntry.new
      entry.value = value
      entry.depth = depth
      if value <= orig_alpha
        entry.type = :upper_bound
      elsif value >= beta
        entry.type = :lower_bound
      else
        entry.type = :exact
      end
      @table[key] = entry
    end

    private
      def parameters_for_entry(entry, value, alpha, beta)
        if entry.type == :exact
          return [value, alpha, beta]
        end
        alpha_param = (entry.type == :lower_bound) ? [alpha, value].max : alpha
        beta_param = (entry.type == :upper_bound) ? [beta, value].min : beta
        value_param = value if alpha_param >= beta_param
        [value_param, alpha_param, beta_param]
      end
  end
end
