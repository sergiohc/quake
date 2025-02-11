class Table::HeaderComponent < ViewComponent::Base
  renders_many :filters

  def initialize(form:, search_placeholder: "Search...", per_page_options: [5, 10, 15, 20, 25])
    @form = form
    @search_placeholder = search_placeholder
    @per_page_options = per_page_options
  end
end
