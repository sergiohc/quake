# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Internationalization
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
end
