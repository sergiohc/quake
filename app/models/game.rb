class Game < ApplicationRecord
  has_many :kills
  has_many :killers, through: :kills, source: :killer
  has_many :victims, through: :kills, source: :victim

  def players
    Player.where(id: killers.pluck(:id)).or(Player.where(id: victims.pluck(:id))).distinct
  end
end
