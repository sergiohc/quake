class Table::RowComponent < ViewComponent::Base
  def initialize(record:, columns:, actions: [])
    @record = record
    @columns = columns
    @actions = actions
  end
end
