-- USERS: lookups by email, joins by id
CREATE INDEX idx_users_email ON users(email);

-- PROPERTIES: common filters/joins
CREATE INDEX idx_properties_host_id   ON properties(host_id);
CREATE INDEX idx_properties_city      ON properties(city);
CREATE INDEX idx_properties_price     ON properties(nightly_price);

-- BOOKINGS: joins + date-range queries + status filters
CREATE INDEX idx_bookings_user_id     ON bookings(user_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);
CREATE INDEX idx_bookings_dates       ON bookings(start_date, end_date);
CREATE INDEX idx_bookings_status      ON bookings(status);

-- REVIEWS: aggregations & joins
CREATE INDEX idx_reviews_property_id  ON reviews(property_id);
CREATE INDEX idx_reviews_user_id      ON reviews(user_id);

-- PAYMENTS: join + latest-success lookups
CREATE INDEX idx_payments_booking_id  ON payments(booking_id);
CREATE INDEX idx_payments_status      ON payments(status);
CREATE INDEX idx_payments_paid_at     ON payments(paid_at);

-- Optional “covering” indexes if these queries are frequent in your dataset:
-- CREATE INDEX idx_bookings_property_start ON bookings(property_id, start_date);
-- CREATE INDEX idx_payments_success_latest ON payments(booking_id, status, paid_at);
