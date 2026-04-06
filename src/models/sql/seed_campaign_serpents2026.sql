-- Database seed file for existing data and initial setup

BEGIN;

-- Seed campaign into structure for organization
INSERT INTO campaigns (campaign_name, description, start_date)
VALUES (
  'Serpents 2026',
  'Explore the endless jungle of the Mwangi Expanse in an Indiana-Jones style pulp adventure search for lost cities and ancient treasure.',
  '2024-06-08'
)
ON CONFLICT (campaign_name) DO NOTHING;

-- Save seed
COMMIT;
