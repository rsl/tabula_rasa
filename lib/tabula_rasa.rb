require 'tabula_rasa/base'
require 'tabula_rasa/helpers'
require 'tabula_rasa/version'

ActiveSupport.on_load(:action_view) do
  include TabulaRasa::Helpers
end
