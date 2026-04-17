CREATE TABLE IF NOT EXISTS player_outfits (
  id         INT         AUTO_INCREMENT PRIMARY KEY,
  player_id  INT         NOT NULL UNIQUE,
  outfit     JSON        NOT NULL,
  updated_at TIMESTAMP   DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (player_id) REFERENCES players(id)
);

ALTER TABLE crews ADD COLUMN crew_outfit JSON NULL;
-- NULL = crew owner has not run /saveoutfit yet
-- Crew members use personal or default until the owner saves
