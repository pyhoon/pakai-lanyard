# Pakai Lanyard

Version: 0.10

Auth extension for [Pakai Server v6](https://github.com/pyhoon/pakai-server-b4j) — a B4J web framework built with EndsMeet, MiniORM, MiniHtml, HTMX, and AlpineJS.

## Overview

Pakai Lanyard adds session-based authentication (login, register, logout) to any Pakai Server v6 project. It provides reusable B4X classes that can be dropped in as a library to protect routes behind a login page.

## Features

- **AuthFilter** — Servlet filter that guards all routes except `/login`, `/register`, and `/assets/`
- **AuthHandler** — Handles login (GET/POST), register (GET/POST), and logout
- **AuthView** — Login and registration HTML pages built with Bootstrap 5 via MiniHtml DSL
- **UsersModel** — `tbl_users` CRUD: `username`, `email`, `password`, `role`

Also includes a full demo application with product/category management, RESTful API, HTMX-powered frontend, and database auto-setup.

## Usage

1. Drop `release/Lanyard.b4xlib` into your B4J additional libraries folder.
2. Add the four class templates to your project: `AuthFilter`, `AuthHandler`, `AuthView`, `UsersModel`.
3. Register routes in `AppStart`:

```b4j
App.Get("/login", "AuthHandler")
App.Get("/logout", "AuthHandler")
App.Get("/register", "AuthHandler")
App.Post("/login", "AuthHandler")
App.Post("/register", "AuthHandler")
App.srvr.AddFilter("/*", "AuthFilter", False)
```

## Build Configurations

| Database  | Driver                        |
|-----------|-------------------------------|
| SQLite    | sqlite-jdbc-3.7.2 (default)   |
| MariaDB   | mariadb-java-client-3.5.6     |
| MySQL     | mysql-connector-j-9.3.0       |

## Dependencies

- EndsMeet v6.80+, MiniORM, MiniHtml, MiniCSS, MiniJS
- Bootstrap 5.3, HTMX 2.x, AlpineJS 3.x (loaded via CDN)
- B4J IDE 10.5+ / Java JDK

## License

MIT — see [LICENSE.txt](LICENSE.txt)

---

**Support this project**

<a href="https://paypal.me/aeric80/"><img src="https://github.com/pyhoon/pakai-server-b4j/blob/main/source/Objects/www/assets/img/sponsor.png" width="174" title="Buy me a coffee" /></a>
