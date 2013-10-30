module TabulaRasa
  module Helpers
    def tabula_rasa(collection, options = {}, &block)
      TabulaRasa::Base.new(collection, self, options, &block).render
    end
  end
end
