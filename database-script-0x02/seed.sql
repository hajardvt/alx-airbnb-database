
---

# ✅ Task 3 — `database-script-0x02/seed.sql` and `database-script-0x02/README.md`

**`seed.sql`:**
```sql
-- Seed data for AirBnB DB (MySQL 8.x)
-- USE airbnb_db;

-- Users
SET @u_guest = UUID();
SET @u_host1 = UUID();
SET @u_host2 = UUID();
SET @u_admin = UUID();

INSERT INTO User (user_id, first_name, last_name, email, password_hash, phone_number, role)
VALUES
(@u_guest, 'Hajar', 'Halim', 'guest@example.com', 'hashed_pw_guest', '+212600000001', 'guest'),
(@u_host1, 'Amine', 'Bennani', 'host1@example.com',  'hashed_pw_host1', '+212600000002', 'host'),
(@u_host2, 'Sara',  'El Fassi','host2@example.com',  'hashed_pw_host2', '+212600000003', 'host'),
(@u_admin, 'Admin', 'User',    'admin@example.com', 'hashed_pw_admin', '+212600000004', 'admin');

-- Properties
SET @p1 = UUID();
SET @p2 = UUID();
INSERT INTO Property (property_id, host_id, name, description, location, pricepernight)
VALUES
(@p1, @u_host1, 'Medina Loft', 'Stylish loft near the old medina.', 'Casablanca, Morocco', 85.00),
(@p2, @u_host2, 'Tangier Seaview', 'Apartment with panoramic sea view.', 'Tangier, Morocco', 120.00);

-- Bookings
SET @b1 = UUID();
SET @b2 = UUID();
INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, total_price, status)
VALUES
(@b1, @p1, @u_guest, '2025-09-10', '2025-09-12', 85.00*2, 'confirmed'),
(@b2, @p2, @u_guest, '2025-10-01', '2025-10-05', 120.00*4, 'pending');

-- Payments (for confirmed booking only)
SET @pay1 = UUID();
INSERT INTO Payment (payment_id, booking_id, amount, payment_method)
VALUES
(@pay1, @b1, 170.00, 'credit_card');

-- Reviews
SET @r1 = UUID();
INSERT INTO Review (review_id, property_id, user_id, rating, comment)
VALUES
(@r1, @p1, @u_guest, 5, 'Amazing stay! Clean loft and great host.');

-- Messages
SET @m1 = UUID();
SET @m2 = UUID();
INSERT INTO Message (message_id, sender_id, recipient_id, message_body)
VALUES
(@m1, @u_guest, @u_host1, 'Hi! Is early check-in possible?'),
(@m2, @u_host1, @u_guest, 'Hello! Yes, we can arrange early check-in after 11am.');
