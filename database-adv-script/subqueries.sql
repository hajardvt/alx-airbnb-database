-- Non-correlated subquery:
-- Find all properties where the average rating is greater than 4.0
SELECT p.*
FROM properties p
WHERE (
    SELECT AVG(r.rating)
    FROM reviews r
    WHERE r.property_id = p.id
) > 4.0;

-- Correlated subquery:
-- Find all users who have made more than 3 bookings
SELECT u.*
FROM users u
WHERE (
    SELECT COUNT(*)
    FROM bookings b
    WHERE b.user_id = u.id
) > 3;
