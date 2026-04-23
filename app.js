const API = 'http://localhost:5000/api';

// ── AUTH ──
const Auth = {
  getToken: () => localStorage.getItem('rr_token'),
  getUser: () => { try { return JSON.parse(localStorage.getItem('rr_user')); } catch { return null; } },
  isLoggedIn: () => !!localStorage.getItem('rr_token'),
  isAdmin: () => { const u = Auth.getUser(); return u && u.role === 'admin'; },
  save: (token, user) => { localStorage.setItem('rr_token', token); localStorage.setItem('rr_user', JSON.stringify(user)); },
  clear: () => { localStorage.removeItem('rr_token'); localStorage.removeItem('rr_user'); },
  logout(base) {
    Auth.clear();
    toast('Logged out successfully.', 'info');
    const b = base || '..';
    setTimeout(() => window.location.href = b + '/index.html', 800);
  }
};

// ── API HELPER ──
async function api(method, endpoint, body = null, auth = false) {
  const headers = { 'Content-Type': 'application/json' };
  if (auth) headers['Authorization'] = 'Bearer ' + Auth.getToken();
  const opts = { method, headers };
  if (body) opts.body = JSON.stringify(body);
  const res = await fetch(API + endpoint, opts);
  const data = await res.json();
  if (!res.ok) throw new Error(data.message || 'Request failed');
  return data;
}

// ── TOAST ──
function toast(msg, type, duration) {
  type = type || 'info';
  duration = duration || 4000;
  let container = document.getElementById('toast-container');
  if (!container) {
    container = document.createElement('div');
    container.id = 'toast-container';
    document.body.appendChild(container);
  }
  const icons = { success: '✓', error: '✕', info: '→' };
  const el = document.createElement('div');
  el.className = 'toast ' + type;
  el.innerHTML = '<span style="font-size:1rem">' + (icons[type] || '→') + '</span><span>' + msg + '</span>';
  container.appendChild(el);
  setTimeout(() => el.remove(), duration + 400);
}

// ── NAVBAR ──
// base: '..' for pages/ subdirectory, '.' for root index.html
function renderNavbar(activePage, base) {
  base = base || '..';
  const user = Auth.getUser();
  const isAdmin = Auth.isAdmin();
  const navbar = document.getElementById('navbar');
  if (!navbar) return;

  navbar.innerHTML =
    '<a href="' + base + '/index.html" class="nav-logo">' +
      '<div class="logo-icon">' +
        '<svg viewBox="0 0 24 24"><path d="M18.92 6.01C18.72 5.42 18.16 5 17.5 5h-11c-.66 0-1.21.42-1.42 1.01L3 12v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8l-2.08-5.99zM6.85 7h10.29l1.08 3.11H5.77L6.85 7zM19 17H5v-5h14v5z"/><circle cx="7.5" cy="14.5" r="1.5"/><circle cx="16.5" cy="14.5" r="1.5"/></svg>' +
      '</div>' +
      'Rent<span>Ride</span>' +
    '</a>' +
    '<nav class="nav-links" id="nav-links">' +
      '<a href="' + base + '/index.html" class="' + (activePage === 'home' ? 'active' : '') + '">Home</a>' +
      '<a href="' + base + '/pages/vehicles.html" class="' + (activePage === 'vehicles' ? 'active' : '') + '">Vehicles</a>' +
      (user ? '<a href="' + base + '/pages/bookings.html" class="' + (activePage === 'bookings' ? 'active' : '') + '">My Bookings</a>' : '') +
      (isAdmin ? '<a href="' + base + '/pages/admin.html" class="' + (activePage === 'admin' ? 'active' : '') + '">Admin</a>' : '') +
    '</nav>' +
    '<div class="nav-actions">' +
      (user ?
        '<span style="font-size:0.85rem;color:var(--text-muted)">Hi, ' + user.name.split(' ')[0] + '</span>' +
        '<button class="btn btn-outline btn-sm" onclick="Auth.logout(\'' + base + '\')">Logout</button>'
      :
        '<a href="' + base + '/pages/login.html" class="btn btn-ghost btn-sm">Login</a>' +
        '<a href="' + base + '/pages/register.html" class="btn btn-primary btn-sm">Get Started</a>'
      ) +
    '</div>' +
    '<div class="nav-hamburger" id="hamburger" onclick="toggleMobileMenu()">' +
      '<span></span><span></span><span></span>' +
    '</div>';

  window.addEventListener('scroll', () => {
    navbar.classList.toggle('scrolled', window.scrollY > 10);
  });
}

function toggleMobileMenu() {
  const links = document.getElementById('nav-links');
  if (links) links.classList.toggle('mobile-open');
}

// ── FORMAT HELPERS ──
function formatDate(str) {
  if (!str) return '—';
  return new Date(str).toLocaleDateString('en-IN', { day: 'numeric', month: 'short', year: 'numeric' });
}

function formatCurrency(n) {
  return '₹' + Number(n).toLocaleString('en-IN');
}

function capitalize(s) {
  return s ? s.charAt(0).toUpperCase() + s.slice(1) : '';
}

function typeIcon(type) {
  const icons = { car: '🚗', bike: '🏍️', suv: '🚙', van: '🚐', truck: '🚛', scooter: '🛵' };
  return icons[type] || '🚗';
}
