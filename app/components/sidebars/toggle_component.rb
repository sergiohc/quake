# frozen_string_literal: true

module Sidebars
  class ToggleComponent < ViewComponent::Base
    def initialize(user:)
      @user = user
      super
    end

    def render?
      @user&.admin?
    end
  end
end
