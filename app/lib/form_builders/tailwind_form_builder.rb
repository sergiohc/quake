# frozen_string_literal: true

module FormBuilders
  class TailwindFormBuilder < ActionView::Helpers::FormBuilder
    class_attribute :text_field_helpers,
                    default: field_helpers - %i[label check_box radio_button
                                                fields_for fields hidden_field
                                                file_field]

    #  https://blog.testdouble.com/posts/2022-12-05-blending-tailwind-with-rails-forms/
    #  https://tailwindcss-forms.vercel.app/ form examples/tailwind
    #  leans on the FormBuilder class_attribute `field_helpers`
    #  you'll want to add a method for each of the specific helpers listed here if you want to style them

    # rubocop:disable Layout/LineLength, Lint/MissingCopEnableDirective
    TEXT_FIELD_STYLE = "bg-gray-50 text-gray-900 text-sm rounded-lg focus:ring-primary-500 block w-full p-2.5 dark:bg-gray-700 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500"
    SELECT_FIELD_STYLE = "block bg-gray-200 text-gray-700 py-2 px-4 rounded leading-tight focus:outline-none focus:bg-white"
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

    def submit(value = nil, options = {})
      custom_opts, opts = partition_custom_opts(options)
      classes = apply_style_classes(SUBMIT_BUTTON_STYLE, custom_opts)

      super(value, { class: classes }.merge(opts))
    end

    def select(method, choices = nil, options = {}, html_options = {}, &block)
      custom_opts, opts = partition_custom_opts(options)
      classes = apply_style_classes(SELECT_FIELD_STYLE, custom_opts, method)

      labels = labels(method, custom_opts[:label], options)
      field = super(method, choices, opts,
                    html_options.merge({ class: classes }), &block)

      labels + field
    end

    private

    def text_like_field(field_method, object_method, options = {})
      custom_opts, opts = partition_custom_opts(options)

      classes = apply_style_classes(TEXT_FIELD_STYLE, custom_opts,
                                    object_method)

      field = send(field_method, object_method, {
        class: classes,
        title: errors_for(object_method)&.join(" ")
      }.compact.merge(opts).merge({ tailwindifield: true }))

      labels = labels(object_method, custom_opts[:label], options)

      labels + field
    end

    def labels(object_method, label_options, field_options)
      return "".html_safe if label_options == false

      label = tailwind_label(object_method, label_options, field_options)
      # error_label = error_label(object_method, field_options)

      @template.content_tag("div", label,
                            { class: "flex flex-col items-start" })
    end

    def tailwind_label(object_method, label_options, field_options) # rubocop:disable Metrics/MethodLength
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
                     { text: error_message, class: " font-bold text-red-500" }, options)
    end

    def border_color_classes(object_method)
      if errors_for(object_method).present?
        " border-2 border-red-400 focus:border-rose-200"
      else
        " border border-gray-300 focus:border-primary-500 dark:border-gray-600 dark:focus:border-primary-500"
      end
    end

    def apply_style_classes(classes, custom_opts, object_method = nil)
      classes + border_color_classes(object_method) + " #{custom_opts[:class]}"
    end

    CUSTOM_OPTS = %i[label class].freeze
    def partition_custom_opts(opts)
      opts.partition { |k, _v| CUSTOM_OPTS.include?(k) }.map(&:to_h)
    end

    def errors_for(object_method)
      return unless @object.present? && object_method.present?

      @object.errors[object_method]
    end
  end
end
