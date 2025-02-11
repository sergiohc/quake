class Game < ApplicationRecord
  include PgSearch::Model
  include Filterable
  has_many :kills
  has_many :killers, through: :kills, source: :killer
  has_many :victims, through: :kills, source: :victim

  pg_search_scope :search_by_general,
    against: [ :id ],
    using: {
      tsearch: { prefix: true }
    }

  def players
    Player.where(id: killers.pluck(:id)).or(Player.where(id: victims.pluck(:id))).distinct
  end

  def statistics
    {
      total_kills: total_kills,
      kills_by_means: kills_by_means,
      kills_by_world: kills_by_world
    }
  end

  # Mortes por causa de morte
  def kills_by_means
    kills.joins(:death_cause)
         .group("death_causes.code")
         .count
  end

  # Mortes causadas pelo <world>
  def kills_by_world
    kills.where(world_kill: true).count
  end
end
