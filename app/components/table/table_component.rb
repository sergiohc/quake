class Table::TableComponent < ViewComponent::Base
  renders_many :columns, ->(label:, attribute: nil, sort_key: nil, sortable: false, td_class: nil, span_class: nil,  &block) do
    Table::ColumnComponent.new(
      label: label,
      attribute: attribute,
      sort_key: sort_key || attribute,
      td_class: td_class,
      span_class: span_class,
      sortable: sortable,
      &block
    )
  end

  def initialize(records:, sortable: true, actions: [])
    @records = records
    @sortable = sortable
    @actions = actions
  end

  def sort_direction(sort_key)
    params[:sort] == sort_key.to_s ? (params[:direction] == 'asc' ? 'desc' : 'asc') : 'asc'
  end
end
