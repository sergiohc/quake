# frozen_string_literal: true

module Sidebars
  class ToggleComponent < ViewComponent::Base
    def initialize(user:)
      @user = user
      super
    end
  end
end
