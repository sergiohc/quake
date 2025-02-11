# frozen_string_literal: true

module FormBuilders
  class TailwindFormBuilder < ActionView::Helpers::FormBuilder
    class_attribute :text_field_helpers,
                    default: field_helpers - %i[label check_box radio_button
                                                fields_for fields hidden_field
                                                file_field]

    TEXT_FIELD_STYLE = "bg-gray-50 text-gray-900 text-sm rounded-lg focus:ring-primary-500 p-2.5 dark:bg-gray-700 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500"
    SELECT_FIELD_STYLE = "bg-gray-200 text-gray-700 rounded-sm focus:outline-none focus:bg-white border border-gray-300 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white dark:focus:border-primary-500 dark:focus:bg-gray-600 dark:focus:text-white"
    CHECKBOX_STYLE = "w-4 h-4 text-primary-600 bg-gray-100 border-gray-300 rounded-sm focus:ring-primary-500 dark:focus:ring-primary-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600"
    FILE_FIELD_STYLE = "text-sm text-gray-900 border border-gray-300 rounded-lg cursor-pointer bg-gray-50 dark:text-gray-400 focus:outline-none dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400"
    SUBMIT_BUTTON_STYLE = "text-primary-700 hover:text-white border border-primary-700 hover:bg-primary-800 focus:ring-4 focus:outline-none focus:ring-primary-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-2 mb-2 dark:border-primary-500 dark:text-primary-500 dark:hover:text-white dark:hover:bg-primary-500 dark:focus:ring-primary-800"

    text_field_helpers.each do |field_method|
      class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
        def #{field_method}(method, options = {})
          if options.delete(:tailwindifield)
            super
          else
            text_like_field(#{field_method.inspect}, method, options)
          end
        end
      RUBY_EVAL
    end

    def collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
      custom_opts, opts = partition_custom_opts(options)
      classes = apply_style_classes(SELECT_FIELD_STYLE, custom_opts, method)

      label_config = {
        text: custom_opts[:label].is_a?(String) ? custom_opts[:label] : nil,
        position: (custom_opts[:label_position] || :top).to_sym
      }

      field_id = "#{@object_name}_#{method}"
      field = super(method, collection, value_method, text_method, opts, html_options.merge({
        class: classes,
        id: field_id
      }))

      return field if custom_opts[:label] == false

      label_html = generate_label(field_id, label_config[:text])
      container = build_container(label_config[:position], label_html, field)

      container
    end

    def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
      custom_opts, opts = partition_custom_opts(options)
      classes = apply_style_classes(CHECKBOX_STYLE, custom_opts, method)

      field = super(method, opts.merge({
        class: classes,
        title: errors_for(method)&.join(" ")
      }), checked_value, unchecked_value)

      labels(method, custom_opts[:label], options) + field
    end

    def radio_button(method, tag_value, options = {})
      custom_opts, opts = partition_custom_opts(options)
      classes = apply_style_classes(CHECKBOX_STYLE, custom_opts, method)

      field = super(method, tag_value, opts.merge({
        class: classes,
        title: errors_for(method)&.join(" ")
      }))

      labels(method, custom_opts[:label], options) + field
    end

    def file_field(method, options = {})
      custom_opts, opts = partition_custom_opts(options)
      classes = apply_style_classes(FILE_FIELD_STYLE, custom_opts, method)

      field = super(method, opts.merge({
        class: classes,
        title: errors_for(method)&.join(" ")
      }))

      labels(method, custom_opts[:label], options) + field
    end

    def text_area(method, options = {})
      custom_opts, opts = partition_custom_opts(options)
      classes = apply_style_classes(TEXT_FIELD_STYLE, custom_opts, method)

      field = super(method, opts.merge({
        class: classes + " resize-y min-h-[100px]",
        title: errors_for(method)&.join(" ")
      }))

      labels(method, custom_opts[:label], options) + field
    end

    def select(method, choices = nil, options = {}, html_options = {}, &block)
      custom_opts, opts = partition_custom_opts(options)
      classes = apply_style_classes(SELECT_FIELD_STYLE, custom_opts, method)

      label_config = {
        text: custom_opts[:label].is_a?(String) ? custom_opts[:label] : nil,
        position: (custom_opts[:label_position] || :top).to_sym
      }

      field_id = "#{@object_name}_#{method}"
      field = super(method, choices, opts, html_options.merge({
        class: classes,
        id: field_id
      }), &block)

      return field if custom_opts[:label] == false

      label_html = generate_label(field_id, label_config[:text])
      container = build_container(label_config[:position], label_html, field)

      container
    end

    def submit(value = nil, options = {})
      custom_opts, opts = partition_custom_opts(options)
      classes = apply_style_classes(SUBMIT_BUTTON_STYLE, custom_opts)

      super(value, { class: classes }.merge(opts))
    end

    private

    def generate_label(field_id, text)
      return "".html_safe if text.blank?

      @template.content_tag(:label, text, {
        for: field_id,
        class: "block mb-2 text-sm font-medium text-gray-900 dark:text-white"
      })
    end

    def build_container(position, label, field)
      config = {
        top:    { classes: "flex flex-col space-y-1 w-full", order: [ :label, :field ] },
        bottom: { classes: "flex flex-col space-y-1 w-full", order: [ :field, :label ] },
        left:   { classes: "flex flex-row items-center space-x-2 w-full", order: [ :label, :field ] },
        right:  { classes: "flex flex-row items-center space-x-2 w-full", order: [ :field, :label ] }
      }[position] || { classes: "flex flex-col space-y-1 w-full", order: [ :label, :field ] }

      content = config[:order].map { |element| element == :label ? label : field }.join.html_safe
      @template.content_tag(:div, content, class: config[:classes])
    end

    def text_like_field(field_method, object_method, options = {})
      custom_opts, opts = partition_custom_opts(options)
      classes = apply_style_classes(TEXT_FIELD_STYLE, custom_opts, object_method)

      field = send(field_method, object_method, {
        class: classes,
        title: errors_for(object_method)&.join(" ")
      }.compact.merge(opts).merge({ tailwindifield: true }))

      labels(object_method, custom_opts[:label], options) + field
    end

    def labels(object_method, label_options, field_options)
      return "".html_safe if label_options == false

      label = tailwind_label(object_method, label_options, field_options)
      @template.content_tag("div", label, { class: "flex flex-col items-start" })
    end

    def tailwind_label(object_method, label_options, field_options)
      text, label_opts = if label_options.present?
                           [ label_options[:text], label_options.except(:text) ]
      else
                           [ nil, {} ]
      end

      label_classes = label_opts[:class] || "block mb-2 text-sm font-medium text-gray-900 dark:text-white"
      if field_options[:disabled]
        label_classes += " text-primary-800 dark:text-primary-400"
      end
      label(object_method, text, {
        class: label_classes
      }.merge(label_opts.except(:class)))
    end

    def error_label(object_method, options)
      return if errors_for(object_method).blank?

      error_message = @object.errors[object_method].collect(&:titleize).join(", ")
      tailwind_label(object_method,
                     { text: error_message, class: "font-bold text-red-500" }, options)
    end

    def border_color_classes(object_method)
      if errors_for(object_method).present?
        "border-2 border-red-400 focus:border-rose-200"
      else
        "border border-gray-300 focus:border-primary-500 dark:border-gray-600 dark:focus:border-primary-500"
      end
    end

    def apply_style_classes(classes, custom_opts, object_method = nil)
      classes + border_color_classes(object_method) + " #{custom_opts[:class]}"
    end

    CUSTOM_OPTS = %i[label class label_position].freeze
    def partition_custom_opts(opts)
      opts.partition { |k, _v| CUSTOM_OPTS.include?(k) }.map(&:to_h)
    end

    def errors_for(object_method)
      return unless @object.present? && object_method.present?

      @object.errors[object_method]
    end
  end
end
