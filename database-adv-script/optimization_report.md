# Optimization Report

## Initial Query (Unoptimized)
The first version of the query joined **bookings, users, properties, and payments** directly:

```sql
SELECT b.id, u.name, p.title, pay.amount, pay.paid_at
FROM bookings b
JOIN users u ON u.id = b.user_id
JOIN properties p ON p.id = b.property_id
LEFT JOIN payments pay ON pay.booking_id = b.id
WHERE b.start_date >= '2025-01-01' AND b.start_date < '2026-01-01';
