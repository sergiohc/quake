# frozen_string_literal: true

module Breadcrumbs
  class DefaultComponent < ViewComponent::Base
    def initialize(breadcrumbs:, title: nil)
      @breadcrumbs = breadcrumbs
      @title = title || @breadcrumbs.last[:name]
      super
    end

    def render?
      @breadcrumbs.any?
    end

    def breadcrumb_separator
      tag.svg(
        class: "mx-1 h-4 w-4 text-gray-400 rtl:rotate-180",
        aria: { hidden: "true" },
        xmlns: "http://www.w3.org/2000/svg",
        fill: "none",
        viewBox: "0 0 24 24"
      ) do
        tag.path(
          stroke: "currentColor",
          stroke_linecap: "round",
          stroke_linejoin: "round",
          stroke_width: "2",
          d: "m9 5 7 7-7 7"
        )
      end
    end
  end
end
