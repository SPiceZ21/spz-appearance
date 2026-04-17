CREATE TABLE IF NOT EXISTS player_outfits (
  id         INT         AUTO_INCREMENT PRIMARY KEY,
  player_id  INT         NOT NULL UNIQUE,
  outfit     JSON        NOT NULL,
  updated_at TIMESTAMP   DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (player_id) REFERENCES players(id)
);

-- Add crew_outfit column to crews table if it doesn't already exist
-- Ensure MariaDB 10.3.2+ or similar to support IF NOT EXISTS on ALTER TABLE
ALTER TABLE crews ADD COLUMN IF NOT EXISTS crew_outfit JSON NULL;
