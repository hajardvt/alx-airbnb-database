# Partitioning Performance Report

## Goal
Evaluate the impact of **RANGE COLUMNS partitioning by start_date (yearly)** on the `bookings` table.

## Test Query (date-bounded)
```sql
SELECT COUNT(*) AS cnt
FROM bookings_partitioned
WHERE start_date >= '2025-01-01'
  AND start_date <  '2025-07-01';
