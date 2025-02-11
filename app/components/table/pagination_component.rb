class Table::PaginationComponent < ViewComponent::Base
  def initialize(records:)
    @records = records
  end
end
