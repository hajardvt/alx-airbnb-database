# Index Performance Report

## How I measured
- Used `EXPLAIN ANALYZE` before/after creating indexes.
- Ran each query 3–5 times; ignored the first (cold cache) and averaged the rest.

## Test Query A: bookings by city in 2025
```sql
SELECT p.city, COUNT(b.id) AS cnt
FROM bookings b
JOIN properties p ON p.id = b.property_id
WHERE b.start_date >= '2025-01-01' AND b.start_date < '2026-01-01'
GROUP BY p.city
ORDER BY cnt DESC;
