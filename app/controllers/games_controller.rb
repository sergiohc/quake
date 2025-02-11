# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :authenticate_user!

  def index
    @games = Game.all.order(sort_query)
                    .page(params[:page])
                    .per(per_page)

    respond_to do |format|
      format.html
    end
  end

  private

  def sort_query
    return unless params[:sort].present?

    column = params[:sort]
    direction = %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"

    { column => direction }
  end

  def per_page
    params[:per_page] || 15
  end
end
