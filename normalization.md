
---

# ✅ Task 1 — `normalization.md`

```markdown
# Normalization to 3NF — AirBnB Database

This document explains how the schema satisfies 1NF, 2NF, and 3NF, and any adjustments made.

## 1NF (Atomicity, No Repeating Groups)
- All attributes are atomic (e.g., `first_name`, `last_name`—no multi-valued fields).
- No repeating groups or arrays inside a column.
- Separate tables for messages, reviews, payments, etc.

**Action required:** none (spec already atomic).

## 2NF (No Partial Dependency on a Composite Key)
- Each table has a single-attribute primary key (`*_id` UUID).  
- Therefore, there are no partial dependencies (no composite PKs).

**Action required:** none.

## 3NF (No Transitive Dependencies)
- **User**: non-key attributes (`first_name`, `last_name`, `email`, `password_hash`, `phone_number`, `role`, `created_at`) depend only on `user_id`. No transitive dependency (e.g., no field that depends on `email` rather than the PK).
- **Property**: attributes like `name`, `description`, `location`, `pricepernight` depend solely on `property_id`. `host_id` is an FK; no derived attributes from `host`.
- **Booking**: `total_price` could be derived from `pricepernight` × nights, but we keep it for performance/cost reasons (a denormalized convenience). It does **not** violate 3NF if treated as a cached value that is consistent at write-time. All other attributes depend on `booking_id`.
- **Payment**: depends on `payment_id`. `amount`, `payment_method`, `payment_date` are properties of the payment, not the booking.
- **Review**: `rating`, `comment`, `created_at` depend only on `review_id`.
- **Message**: `message_body`, `sent_at` depend only on `message_id`.

**Action taken:**
- Ensured enumerations (`role`, `status`, `payment_method`) are domain constraints, not separate lookup tables (acceptable for 3NF; if you prefer lookup tables, that would be BCNF-friendly but not mandatory).
- Ensured no fields like `host_name` in `Property` to avoid transitive dependency via `host_id`.
- Indexes placed on FKs and frequently searched columns to support performance without breaking normalization.

## Optional Design Choices Considered
- **One Review per (user, property)**: could add `UNIQUE(user_id, property_id)` to enforce at most one active review per user/property pair. This is a business rule, not a normalization requirement.
- **Booking overlap checks**: overlap constraints typically require application/business logic or database constraints/triggers; not a normalization concern.

## Conclusion
The schema, as specified and adjusted, satisfies **3NF**. Any “derived” attributes are optional and documented as denormalized for performance with write-time consistency guarantees.
