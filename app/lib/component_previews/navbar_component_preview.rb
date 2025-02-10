# frozen_string_literal: true

class NavbarComponentPreview < Lookbook::Preview
  def default
    render(NavbarComponent.new)
  end
end
