# frozen_string_literal: true

module Sidebars
  class DefaultComponent < ViewComponent::Base
    include ApplicationHelper
    include Rails.application.routes.url_helpers

    def initialize(user:)
      @user = user
      super
    end
  end
end
