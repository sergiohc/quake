class LogImporter
  DEATH_CAUSES = {
    0 => "MOD_UNKNOWN",
    1 => "MOD_SHOTGUN",
    2 => "MOD_GAUNTLET",
    3 => "MOD_MACHINEGUN",
    4 => "MOD_GRENADE",
    5 => "MOD_GRENADE_SPLASH",
    6 => "MOD_ROCKET",
    7 => "MOD_ROCKET_SPLASH",
    8 => "MOD_PLASMA",
    9 => "MOD_PLASMA_SPLASH",
    10 => "MOD_RAILGUN",
    11 => "MOD_LIGHTNING",
    12 => "MOD_BFG",
    13 => "MOD_BFG_SPLASH",
    14 => "MOD_WATER",
    15 => "MOD_SLIME",
    16 => "MOD_LAVA",
    17 => "MOD_CRUSH",
    18 => "MOD_TELEFRAG",
    19 => "MOD_FALLING",
    20 => "MOD_SUICIDE",
    21 => "MOD_TARGET_LASER",
    22 => "MOD_TRIGGER_HURT",
    23 => "MOD_GRAPPLE"
  }.freeze

  def initialize(log_path)
    @log_path = log_path
  end

  def call
    ActiveRecord::Base.transaction do
      current_game = nil

      File.foreach(@log_path) do |line|
        if line.include?("InitGame:")
          current_game = create_game(line)
        elsif line.include?("Kill: ") && current_game
          process_kill(line, current_game)
        elsif line.include?("ShutdownGame:") && current_game
          finalize_game(current_game, line)
        end
      end
    end
  end

  private

  def create_game(line)
    Game.create!(
      start_time_seconds: extract_timestamp(line),
    )
  end

  def process_kill(line, game)
    match = line.match(/Kill: (\d+) (\d+) (\d+)/)
    return unless match

    killer_id, victim_id, mod_code = match.captures
    mod_code = mod_code.to_i

    killer = killer_id == "1022" ? nil : find_or_create_player(killer_id)
    victim = find_or_create_player(victim_id)

    Kill.create!(
      game: game,
      time_seconds: extract_timestamp(line),
      killer: killer,
      victim: victim,
      death_cause: find_death_cause(mod_code),
      world_kill: killer_id == "1022",
    )
  end

  def find_or_create_player(player_id)
    Player.find_or_create_by!(username: "Player_#{player_id}")
  end

  def find_death_cause(mod_code)
    DeathCause.find_or_create_by!(
      code: DEATH_CAUSES[mod_code] || "MOD_UNKNOWN",
      name: DEATH_CAUSES[mod_code] || "Unknown"
    )
  end

  def extract_timestamp(line)
    # Usa regex para capturar o timestamp no formato MM:SS ou HHH:MM:SS
    match = line.match(/^\s*(\d{1,5}:\d{2})/)
    return 0 unless match

    time_part = match[1]

    # Divide em partes e converte para inteiros
    parts = time_part.split(":").map(&:to_i)

    if parts.size == 3  # Formato HHH:MM:SS
      hours, minutes, seconds = parts
      hours * 3600 + minutes * 60 + seconds
    else                # Formato MM:SS
      minutes, seconds = parts
      minutes * 60 + seconds
    end
  rescue
    0
  end

  def finalize_game(game, line)
    game.update!(
      end_time_seconds: extract_timestamp(line),
      total_kills: game.kills.count
    )
  end
end
