module Filterable
  extend ActiveSupport::Concern

  class_methods do
    def apply_filters(params)
      scope = all
      scope = scope.search_by_general(params[:query]) if params[:query].present?

      scope
    end
  end
end
