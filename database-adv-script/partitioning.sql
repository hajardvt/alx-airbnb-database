/* ===============================
   Partitioning Bookings by start_date (MySQL 8)
   Strategy: create a partitioned copy, load data, (optionally) swap.
   =============================== */

-- 0) Safety: adjust names if you already use these
DROP TABLE IF EXISTS bookings_partitioned;

-- 1) Create partitioned table (YEAR partitions by start_date)
CREATE TABLE bookings_partitioned (
  id            BIGINT PRIMARY KEY,
  user_id       BIGINT NOT NULL,
  property_id   BIGINT NOT NULL,
  start_date    DATE   NOT NULL,
  end_date      DATE   NOT NULL,
  status        ENUM('created','confirmed','cancelled','completed') NOT NULL,
  total_amount  DECIMAL(10,2) NOT NULL,
  created_at    DATETIME NOT NULL,
  KEY idx_b_user_id      (user_id),
  KEY idx_b_property_id  (property_id),
  KEY idx_b_dates        (start_date, end_date)
)
PARTITION BY RANGE COLUMNS(start_date) (
  PARTITION p2023 VALUES LESS THAN ('2024-01-01'),
  PARTITION p2024 VALUES LESS THAN ('2025-01-01'),
  PARTITION p2025 VALUES LESS THAN ('2026-01-01'),
  PARTITION pmax  VALUES LESS THAN (MAXVALUE)
);

-- 2) Load data from existing (non-partitioned) table
-- (If the table is huge, consider chunked inserts by year)
INSERT INTO bookings_partitioned
  (id, user_id, property_id, start_date, end_date, status, total_amount, created_at)
SELECT
  id, user_id, property_id, start_date, end_date, status, total_amount, created_at
FROM bookings;

-- 3) Example query that benefits from partition pruning (date-bounded)
EXPLAIN ANALYZE
SELECT COUNT(*) AS cnt
FROM bookings_partitioned
WHERE start_date >= '2025-01-01'
  AND start_date <  '2025-07-01';

-- 4) Optional: monthly partitions for heavy write/read patterns
-- (commented example)
-- ALTER TABLE bookings_partitioned
-- PARTITION BY RANGE COLUMNS(start_date) (
--   PARTITION p2025m01 VALUES LESS THAN ('2025-02-01'),
--   PARTITION p2025m02 VALUES LESS THAN ('2025-03-01'),
--   ...
--   PARTITION pmax    VALUES LESS THAN (MAXVALUE)
-- );

-- 5) Maintenance: add next-year partition ahead of time
-- ALTER TABLE bookings_partitioned
-- ADD PARTITION (PARTITION p2026 VALUES LESS THAN ('2027-01-01'));
