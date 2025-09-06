-- INNER JOIN: all bookings with the users who made them
SELECT b.id AS booking_id, b.start_date, b.end_date, u.id AS user_id, u.name, u.email
FROM bookings b
INNER JOIN users u ON u.id = b.user_id;

-- LEFT JOIN: all properties with their reviews (including properties with no reviews)
SELECT p.id AS property_id, p.title, r.id AS review_id, r.rating, r.comment
FROM properties p
LEFT JOIN reviews r ON r.property_id = p.id
ORDER BY p.id, r.created_at;

-- FULL OUTER JOIN: all users and all bookings, even if unmatched
-- Note: MySQL doesn’t support FULL OUTER JOIN directly, so we emulate it with UNION.
SELECT u.id AS user_id, u.name, b.id AS booking_id, b.start_date
FROM users u
LEFT JOIN bookings b ON b.user_id = u.id
UNION
SELECT u.id AS user_id, u.name, b.id AS booking_id, b.start_date
FROM bookings b
RIGHT JOIN users u ON b.user_id = u.id;
