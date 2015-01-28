module Kanban
  class Config
    def self.board_ids
      Rails.application.config.lean_kit_board_ids
    end
    def self.backlog_lanes
      Rails.application.config.lean_kit_backlog_lanes
    end
    def self.active_lanes
      Rails.application.config.lean_kit_active_lanes
    end
    def self.completed_lanes
      Rails.application.config.lean_kit_completed_lanes
    end
  end
end
