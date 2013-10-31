require 'tabula_rasa/column'

module TabulaRasa
  class Base
    attr_reader :collection, :view, :klass, :columns, :options

    delegate :content_tag, :safe_join, to: :view

    def initialize(collection, view, options = {}, &block)
      raise ArgumentError, 'TabulaRasa only works on ActiveRecord Relation instances' unless collection.is_a?(ActiveRecord::Relation)
      @collection = collection
      @options = options
      @view = view
      @klass = collection.klass
      @columns = []
      yield self if block_given?
    end

    def render
      return if columns.empty?
      content_tag :table, content, table_options
    end

    def column(*args, &block)
      @columns << Column.new(self, *args, &block)
    end

  private

    def content
      safe_join [thead, tbody]
    end

    def thead
      content_tag :thead, options[:head] do
        content_tag :tr do
          safe_join columns.map(&:head_content)
        end
      end
    end

    def tbody
      content_tag :tbody, options[:body] do
        collection.present? ? collection_body : empty_body
      end
    end

    def collection_body
      rows = collection.map do |member|
        content_tag :tr do
          cells = columns.map do |column|
            column.body_content_for member
          end
          safe_join cells
        end
      end
      safe_join rows
    end

    def table_options
      options.except :head, :body
    end
  end
end
