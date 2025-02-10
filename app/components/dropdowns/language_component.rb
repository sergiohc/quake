# frozen_string_literal: true

module Dropdowns
  class LanguageComponent < ViewComponent::Base
    def initialize # rubocop:disable Lint/UselessMethodDefinition
      super
    end

    private

    def flag_icon_class(locale)
      flag_map = {
        "pt-BR" => "br",
        "en" => "us"
      }
      flag_map[locale.to_s] || locale.to_s.downcase
    end
  end
end
