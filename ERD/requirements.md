# AirBnB Database — ERD Requirements

## 1) Entities & Attributes

### User
- `user_id` (PK, UUID, indexed)
- `first_name` (varchar, not null)
- `last_name` (varchar, not null)
- `email` (varchar, unique, not null)
- `password_hash` (varchar, not null)
- `phone_number` (varchar, null)
- `role` (enum: `guest`, `host`, `admin`, not null)
- `created_at` (timestamp, default now)

### Property
- `property_id` (PK, UUID, indexed)
- `host_id` (FK → User.user_id)
- `name` (varchar, not null)
- `description` (text, not null)
- `location` (varchar, not null)
- `pricepernight` (decimal, not null)
- `created_at` (timestamp, default now)
- `updated_at` (timestamp, auto-updated)

### Booking
- `booking_id` (PK, UUID, indexed)
- `property_id` (FK → Property.property_id)
- `user_id` (FK → User.user_id)
- `start_date` (date, not null)
- `end_date` (date, not null)
- `total_price` (decimal, not null)
- `status` (enum: `pending`, `confirmed`, `canceled`, not null)
- `created_at` (timestamp, default now)

### Payment
- `payment_id` (PK, UUID, indexed)
- `booking_id` (FK → Booking.booking_id)
- `amount` (decimal, not null)
- `payment_date` (timestamp, default now)
- `payment_method` (enum: `credit_card`, `paypal`, `stripe`, not null)

### Review
- `review_id` (PK, UUID, indexed)
- `property_id` (FK → Property.property_id)
- `user_id` (FK → User.user_id)
- `rating` (int, 1–5, not null)
- `comment` (text, not null)
- `created_at` (timestamp, default now)

### Message
- `message_id` (PK, UUID, indexed)
- `sender_id` (FK → User.user_id)
- `recipient_id` (FK → User.user_id)
- `message_body` (text, not null)
- `sent_at` (timestamp, default now)

---

## 2) Relationships (Cardinality)

- **User (host) 1—N Property**  
  One user (role `host`) can own many properties; each property belongs to one host.

- **User 1—N Booking**  
  One user (guest) can create many bookings; each booking is created by one user.

- **Property 1—N Booking**  
  One property can have many bookings; each booking is for one property.

- **Booking 1—1 Payment** (logical; can be enforced 1—0..1 if partial payments allowed)  
  Each booking has at most one payment record.

- **Property 1—N Review** and **User 1—N Review**  
  Reviews are authored by users on properties.

- **User 1—N Message (as sender)** and **User 1—N Message (as recipient)**  
  Messaging is user-to-user.

---

## 3) Diagram 
