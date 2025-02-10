# frozen_string_literal: true

# frozen_string_literal: true

class NavbarComponent < ViewComponent::Base
  def initialize(user:)
    @user = user
    super
  end
end
