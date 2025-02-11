class Table::ActionComponent < ViewComponent::Base
  def initialize(record:, actions:)
    @record = record
    @actions = actions
  end

  def path_for(action)
    case action
    when :show
      @record
    when :edit
      [ :edit, @record ]
    when :destroy
      @record
    end
  end

  def render?
     @actions.blank?
  end

  def method_for(action)
    action == :destroy ? :delete : :get
  end
end
