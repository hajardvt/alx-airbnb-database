# Performance Monitoring & Refinement

## Tools (MySQL 8)
- `EXPLAIN FORMAT=TREE <query>;` → shows query plan structure.
- `EXPLAIN ANALYZE <query>;` → runs the query and provides timing.
- Optional: `SET profiling=1; SHOW PROFILES; SHOW PROFILE FOR QUERY X;` if profiling is enabled.

---

## Example 1 — Bookings by City
```sql
SELECT p.city, COUNT(*) AS cnt
FROM bookings b
JOIN properties p ON p.id = b.property_id
WHERE b.start_date >= '2025-01-01' AND b.start_date < '2026-01-01'
GROUP BY p.city
ORDER BY cnt DESC;
