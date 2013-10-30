module TabulaRasa
  class Column
    delegate :capture, :content_tag, :truncate, to: :base

    def initialize(base, *args, &block)
      @base = base
      @attribute = args.first
      @options = args.extract_options!
      yield self if block_given?
      massage_options
      ensure_valueable
    end

    def head_content
      content_tag :th, head_value, options[:head]
    end

    def head
      raise ArgumentError, "There's no need to pass a block for head. It's only evaluated once. Just set the head value via options or attribute [if appropriate]."
    end

    def body_content_for(instance)
      content_tag :td, body_value_for(instance), options[:body]
    end

    def body(&block)
      @body_value_option = block if block_given?
    end

  private

    attr_reader :base, :attribute, :options, :head_value_option, :body_value_option

    def ensure_valueable
      ensure_head_valueable
      ensure_body_valueable
    end

    def ensure_head_valueable
      raise ArgumentError, 'Head value cannot be determined from arguments' unless head_value_option.present? || attribute.present?
    end

    def ensure_body_valueable
      return if body_value_option.present? || base.collection.empty?
      unless attribute.present? && base.collection.first.respond_to?(attribute)
        raise ArgumentError, "Body value cannot be determined from arguments. #{base.klass} does not respond to #{attribute.inspect}."
      end
    end

    def massage_options
      @head_value_option = options[:head].is_a?(Hash) ? options[:head].delete(:value) : options.delete(:head)
      # Allow for body_value_option having been set by body block. Do not allow overriding this!
      @body_value_option ||= options[:body].is_a?(Hash) ? options[:body].delete(:value) : options.delete(:body)
    end

    def head_value
      name = head_value_option || attribute
      name.to_s.humanize.titleize
    end

    def body_value_for(instance)
      value = body_value_option || instance.send(attribute)
      if value.respond_to?(:call)
        value.call(instance)
      else
        truncate value.to_s
      end
    end
  end
end
