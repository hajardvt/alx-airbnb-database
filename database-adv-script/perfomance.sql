-- perfomance.sql

-- Initial query (unoptimized, joins everything)
SELECT b.id, u.name, p.title, pay.amount, pay.paid_at
FROM bookings b
JOIN users u ON u.id = b.user_id
JOIN properties p ON p.id = b.property_id
LEFT JOIN payments pay ON pay.booking_id = b.id
WHERE b.start_date >= '2025-01-01' AND b.start_date < '2026-01-01';

-- Refactored query (optimized with latest payment)
WITH latest_payment AS (
  SELECT pp.*
  FROM payments pp
  JOIN (
    SELECT booking_id, MAX(paid_at) AS max_paid_at
    FROM payments
    WHERE status = 'success'
    GROUP BY booking_id
  ) t ON t.booking_id = pp.booking_id AND t.max_paid_at = pp.paid_at
)
SELECT b.id, u.name, p.title, lp.amount, lp.paid_at
FROM bookings b
JOIN users u ON u.id = b.user_id
JOIN properties p ON p.id = b.property_id
LEFT JOIN latest_payment lp ON lp.booking_id = b.id
WHERE b.start_date >= '2025-01-01' AND b.start_date < '2026-01-01';
