# 👥 Flutter User List App

A Flutter assignment app that fetches and displays a list of users using the [ReqRes API](https://reqres.in/).  
It demonstrates Clean Architecture, BLoC (Cubit), pagination, search, caching, and offline handling.

---

## 📱 Features

- 🔍 User List with name & profile picture
- 🧑‍💼 User Detail Screen (name, email, phone, picture)
- 🔎 Search users by name
- 🔄 Infinite Scrolling with API Pagination
- 📴 Offline support (fallback to cache if no internet)
- 💾 Caching using SharedPreferences
- 🔁 Pull to Refresh
- ⚠️ Graceful Error Handling & Retry

---

## 🧱 Architecture

Uses **Feature-First Clean Architecture** with:
- **Cubit** (Flutter BLoC) for State Management
- **Http** for API requests
- **SharedPreferences** for local caching
- **Connectivity Plus** for network awareness
