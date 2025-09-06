-- 1) Aggregation: total number of bookings made by each user
SELECT
  u.id   AS user_id,
  u.name AS user_name,
  COUNT(b.id) AS total_bookings
FROM users u
LEFT JOIN bookings b ON b.user_id = u.id
GROUP BY u.id, u.name
ORDER BY total_bookings DESC, user_name;

-- 2) Window functions: rank properties by total number of bookings
-- Compute booking counts per property
WITH booking_totals AS (
  SELECT
    p.id AS property_id,
    p.title,
    COUNT(b.id) AS bookings_count
  FROM properties p
  LEFT JOIN bookings b ON b.property_id = p.id
  GROUP BY p.id, p.title
)
SELECT
  property_id,
  title,
  bookings_count,
  ROW_NUMBER() OVER (ORDER BY bookings_count DESC, title) AS row_number_rank,
  RANK()       OVER (ORDER BY bookings_count DESC, title) AS rank_ties_share
FROM booking_totals
ORDER BY bookings_count DESC, title;
