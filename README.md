# Epsum Stock System


## Overview

Epsum Stock System is a simple prototype application for stock management and control.


## Features

- Users can register their accounts.
- Users can authenticate through the system.
- Users can log out from the system.
- Users can view information on the dashboard.
- Users can manage products.
- Users can manage categories.
- Users can manage customers.
- Users can manage orders.
- Users can manage sales.
- Users can manage their accounts.
- Users can switch the language between English or Portuguese.

## Technologies

- Spring Boot
- Spring Web MVC
- Spring Security
- Spring Data JPA with Hibernate
- Thymeleaf
- Bootstrap
- AlpineJS
- Postgres

## Getting Started

### Prerequisites

* Java 21
* Docker
* Docker Compose

Start the application

```bash
  ./gradlew bootRun --args="--spring.profiles.active=local"
```

The application will start at `http://localhost:8080/`
with a default user with email `user@email.com` and password `password` with prefilled data.

The email client will start at `http://localhost:8025/`, use it to verify a new created account 
or reset an account password.

The database admin panel will start at `http://localhost:5050/`, use it to manage the database.

### Tests

This project contains a lot of unit and integration tests, use the following command to run them.

```bash
  ./gradlew test
```