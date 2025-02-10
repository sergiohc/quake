# frozen_string_literal: true

module Dropdowns
  class UserAvatarComponent < ViewComponent::Base
    include Devise::Controllers::Helpers

    def initialize(user:, is_stacked: false)
      @user = user
      @is_stacked = is_stacked
      super
    end

    def render?
      @user.present? || @is_stacked
    end

    private

    def image_profile
      image_tag(asset_path("blank-profile.svg"),
                class: "w-8 h-8 rounded-full",
                alt: "user photo")
    end

    def links
      content_tag(:ul, class: "py-1", role: "none") do
        if user_signed_in?
          safe_join([ loged_out ])
        else
          loged_in
        end
      end
    end

    def loged_in
      content_tag(:li) do
        link_to(new_user_session_path,
                class: "block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-gray-600 dark:hover:text-white", role: "menuitem") do
          "Sign in"
        end
      end
    end

    def loged_out
      content_tag(:li) do
        link_to(destroy_user_session_path,
                data: { turbo_method: :delete },
                class: "block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-gray-600 dark:hover:text-white",
                role: "menuitem") do
          "Sign out"
        end
      end
    end
  end
end
