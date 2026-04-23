# 🚗 RentRide — Vehicle Rental Web App

Full-stack vehicle rental platform · Node.js + Express + MySQL + Vanilla JS

---

## 🚀 Quick Start (3 steps)

### Step 1 — Import the database

```bash
mysql -u root -p < rentride_db.sql
```

Or open **phpMyAdmin → Import → choose `rentride_db.sql`**

### Step 2 — Configure & start the backend

```bash
cd backend
# Edit .env — set your MySQL password if you have one:
#   DB_PASSWORD=yourpassword

npm install
npm run dev
```

You'll see:
```
✅ Database ready
🚗  RentRide running at  →  http://localhost:5000
🔑  Admin login          →  admin@rentride.in / Admin@123
```

### Step 3 — Open in browser

```
http://localhost:5000
```

That's it. The backend serves the frontend automatically.

---

## 🔑 Default Credentials

| Role  | Email              | Password  |
|-------|--------------------|-----------|
| Admin | admin@rentride.in  | Admin@123 |

Register any new account for regular user access.

---

## 🔧 Troubleshooting Login Issues

If you get "Invalid email or password":

1. **Make sure the server started without errors** — check terminal output
2. **The server auto-fixes the admin password on every startup** — if you imported the SQL and then started the server, the password will be correctly set to `Admin@123`
3. **DB_PASSWORD in .env** — if your MySQL has a password, set it in `backend/.env`
4. Run this SQL to manually reset the admin (replace hash if needed):
   ```sql
   USE rentride;
   -- Delete and let the server re-seed
   DELETE FROM users WHERE email='admin@rentride.in';
   -- Then restart the server — it will recreate admin with correct password
   ```

---

## 📁 Project Structure

```
rentride/
├── rentride_db.sql          ← Import this first
├── README.md
├── backend/
│   ├── .env                 ← Set DB_PASSWORD here
│   ├── .env.example
│   ├── package.json
│   ├── server.js
│   ├── config/db.js         ← Auto-creates tables, seeds admin & vehicles
│   ├── middleware/auth.js   ← JWT middleware
│   └── routes/
│       ├── auth.js          ← /api/auth/register, /login, /me
│       ├── vehicles.js      ← /api/vehicles  (CRUD)
│       └── bookings.js      ← /api/bookings  (book, list, cancel, stats)
└── frontend/
    ├── index.html           ← Home page
    ├── css/style.css        ← Dark theme + orange accent
    ├── js/app.js            ← Shared utilities (API, Auth, Toast)
    └── pages/
        ├── login.html
        ├── register.html
        ├── vehicles.html        ← Browse & filter fleet
        ├── vehicle-detail.html  ← Details + inline booking form
        ├── bookings.html        ← My bookings history
        └── admin.html           ← Admin dashboard
```

---

## 🌐 API Reference

### Auth  `/api/auth`
| Method | Route       | Auth | Description     |
|--------|-------------|------|-----------------|
| POST   | /register   | No   | Create account  |
| POST   | /login      | No   | Get JWT token   |
| GET    | /me         | Yes  | Current user    |

### Vehicles  `/api/vehicles`
| Method | Route  | Auth  | Description          |
|--------|--------|-------|----------------------|
| GET    | /      | No    | List (with filters)  |
| GET    | /:id   | No    | Single vehicle       |
| POST   | /      | Admin | Add vehicle          |
| PUT    | /:id   | Admin | Update vehicle       |
| DELETE | /:id   | Admin | Delete vehicle       |

Query params: `?type=car&location=Mumbai&available=true&search=swift`

### Bookings  `/api/bookings`
| Method | Route          | Auth  | Description         |
|--------|----------------|-------|---------------------|
| POST   | /              | User  | Create booking      |
| GET    | /my            | User  | My bookings         |
| GET    | /all           | Admin | All bookings        |
| GET    | /stats         | Admin | Dashboard stats     |
| PUT    | /:id/cancel    | User  | Cancel booking      |
| PUT    | /:id/status    | Admin | Update status       |

---

## 🛡️ Security
- Passwords hashed with **bcrypt** (cost factor 10)
- **JWT** tokens (7-day expiry)
- Role-based access control (user / admin)
- SQL injection prevention via parameterized queries
- Overlap booking detection

## 🎨 Tech Stack
- **Frontend**: HTML5, CSS3, Vanilla JS (no framework)
- **Backend**: Node.js, Express.js
- **Database**: MySQL 8 with mysql2/promise
- **Auth**: bcryptjs + jsonwebtoken
- **Fonts**: Google Fonts — Syne + DM Sans
