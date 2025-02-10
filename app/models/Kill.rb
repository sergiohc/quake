class Kill < ApplicationRecord
  belongs_to :game
  belongs_to :killer, class_name: "Player", optional: true
  belongs_to :victim, class_name: "Player"
  belongs_to :death_cause
end
