# frozen_string_literal: true

module ApplicationHelper
  ActionView::Base.default_form_builder = FormBuilders::TailwindFormBuilder

  def show_icon(path)
    File.open("app/assets/images/icons/#{path}", "rb") do |file|
      raw file.read # rubocop:disable Rails/OutputSafety
    end
  end
end
