module TabulaRasa
  class Row
    # NOTE: Need to handle ALL valid HTML5 attributes
    ATTRIBUTES = [:id, :class]

    delegate :cycle, :dom_id, :dom_class, to: :base

    def initialize(base, options = {}, &block)
      @base = base
      @options = options
      yield self if block_given?
    end

    def options_for(instance)
      {
        id: [id_value_for(instance), dom_id_for(instance)].compact.join(' ').squish,
        class: [class_value_for(instance), zebrastripe, dom_class_for(instance)].compact.join(' ').squish
      }.merge data_values_for(instance)
    end

    def data(key, &block)
      options[:data] ||= {}
      options[:data][key] = block
    end

    ATTRIBUTES.each do |attribute|
      define_method attribute do |&block|
        options[attribute] = block
      end
    end

  private

    attr_reader :base, :options

    def zebrastripe
      case base.options[:zebra]
      when false
        # Nothing
      when nil
        cycle *%w{even odd}
      when Array
        cycle *base.options[:zebra]
      else
        raise ArgumentError, "Invalid value for options[:zebra]: #{base.options[:zebra]}. Should be array."
      end
    end

    def dom_id_for(instance)
      return unless base.options[:dom_id] == true
      dom_id(instance) unless id_value_for(instance).present?
    end

    def dom_class_for(instance)
      dom_class(instance) if base.options[:dom_class] == true
    end

    def data_values_for(instance)
      return {} if options[:data].blank?
      options[:data].inject({}) do |m, x|
        key, value = x
        m["data-#{key}"] = value.call(instance)
        m
      end
    end

    ATTRIBUTES.each do |attribute|
      define_method "#{attribute}_value_for" do |instance|
        value = options[attribute]
        if value.respond_to?(:call)
          value.call instance
        else
          value.to_s
        end
      end
    end
  end
end
