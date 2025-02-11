class Table::ColumnComponent < ViewComponent::Base
  attr_reader :label, :attribute, :sort_key, :sortable, :td_class, :span_class

  def initialize(label:, attribute: nil, sort_key: nil, sortable: false, td_class: nil, span_class: nil, &block)
    @label = label
    @attribute = attribute
    @sort_key = sort_key
    @sortable = sortable
    @td_class = td_class
    @span_class = span_class
    @content_block = block
  end

  def call(record)
    if @content_block
      @content_block.call(record)
    elsif @attribute
      record.public_send(@attribute)
    else
      ""
    end
  end

  def render_td(record)
    content_tag :td, class: td_class.presence do
      content = call(record)

      if span_class.present?
        content_tag(:span, content, class: span_class)
      else
        content
      end
    end
  end
end
