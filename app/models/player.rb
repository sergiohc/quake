class Player < ApplicationRecord
  has_many :kills_as_killer, class_name: "Kill", foreign_key: "killer_id"
  has_many :kills_as_victim, class_name: "Kill", foreign_key: "victim_id"

  # Número de vezes que o jogador matou alguém em uma partida
  def kill_count_in_game(game)
    kills_as_killer.where(game: game).count
  end

  # Número de vezes que o jogador foi morto em uma partida
  def death_count_in_game(game)
    kills_as_victim.where(game: game).count
  end
end
