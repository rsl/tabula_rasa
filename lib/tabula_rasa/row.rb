module TabulaRasa
  class Row
    delegate :cycle, to: :base

    def initialize(base, options = {}, &block)
      @base = base
      @options = options
      yield self if block_given?
    end

    def options
      {
        class: cycle(*%w{even odd})
      }
    end

  private

    attr_reader :base
  end
end
