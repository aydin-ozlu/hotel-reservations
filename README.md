
# Hotel Reservation Microservices Project

This project is a hotel reservation system developed using microservices architecture.

It includes three main services:

- **Hotel Service** — Manages hotels and rooms  
- **Reservation Service** — Handles reservation operations with Kafka-based event-driven communication  
- **Notification Service** — Kafka consumer that listens for reservation notifications  

Additionally, a centralized **API Gateway** and **Authentication Service** exist for all services.

---

## Table of Contents

- [Architecture Overview](#architecture-overview)  
- [Services and Ports](#services-and-ports)  
- [Running with Docker Compose](#running-with-docker-compose)  
- [API Gateway Usage](#api-gateway-usage)  
- [JWT Authentication](#jwt-authentication)  
- [API Endpoints](#api-endpoints)  
- [Using Postman](#using-postman)  
- [Error Handling](#error-handling)  
- [Development Notes](#development-notes)  

---

## Architecture Overview

- Each service is independent and written with Spring Boot.  
- Kafka provides event-driven communication between services.  
- PostgreSQL is used as the database for hotels and reservations.  
- API Gateway serves as the external access point and routes requests to corresponding services.  
- Authentication Service provides JWT-based authentication.  

---

## Services and Ports

| Service              | Port  | Description                           |
|----------------------|-------|-------------------------------------|
| API Gateway          | 8080  | Entry point for all requests         |
| Hotel Service        | 8081  | Manages hotels and rooms             |
| Reservation Service  | 8082  | Handles reservation operations       |
| Notification Service | 8083  | Listens to Kafka reservation events |
| Auth Service         | 8084  | Provides login API for JWT token     |

---

## Running with Docker Compose

Run the following command in the project root directory to start all services:

```bash
docker-compose up --build
```

Kafka and Zookeeper containers start automatically.  
Postgres container prepares the database.  
Each service runs on its own port.

---

## API Gateway Usage

All API calls should go through the API Gateway. Examples:

- List hotels:  
  `http://localhost:8080/hotel-service/hotels`

- List rooms:  
  `http://localhost:8080/hotel-service/rooms`

- Reservation service:  
  `http://localhost:8080/reservation-service`

The Gateway routes incoming requests to the relevant service and performs JWT validation.

---

## JWT Authentication

### Getting Token

Send a login request to the Auth service:

```http
POST http://localhost:8084/auth/login?username=user1&password=password
```

Successful login returns a JWT token in JSON format:

```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### Using Token

All requests to the API Gateway must include the token in the Authorization header like this:

```
Authorization: Bearer <token>
```

Example:

```http
GET http://localhost:8080/hotel-service/hotels
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

---

## API Endpoints

### Hotel Service

| Method | Endpoint                      | Description             | Example Payload                                      |
|--------|-------------------------------|-------------------------|-----------------------------------------------------|
| POST   | /hotel-service/hotels          | Create a new hotel      | `{ "name": "Hilton", "address": "NY", "starRating": 5 }` |
| GET    | /hotel-service/hotels          | List all hotels         |                                                     |
| GET    | /hotel-service/hotels/{id}     | Get hotel by ID         |                                                     |
| PUT    | /hotel-service/hotels/{id}     | Update hotel by ID      | `{ "name": "New Hilton", "address": "NY", "starRating": 5 }` |
| DELETE | /hotel-service/hotels/{id}     | Delete hotel by ID      |                                                     |

### Room Service

| Method | Endpoint                        | Description             | Example Payload                                      |
|--------|---------------------------------|-------------------------|-----------------------------------------------------|
| POST   | /hotel-service/rooms             | Create a new room       | `{ "hotelId": 1, "roomNumber": "101", "capacity": 2, "pricePerNight": 150.0 }` |
| GET    | /hotel-service/rooms             | List all rooms          |                                                     |
| GET    | /hotel-service/rooms/hotel/{hotelId} | List rooms by hotel |                                                     |
| GET    | /hotel-service/rooms/{id}        | Get room by ID          |                                                     |
| PUT    | /hotel-service/arooms/{id}       | Update room by ID       | `{ "hotelId": 1, "roomNumber": "102", "capacity": 3, "pricePerNight": 200.0 }` |
| DELETE | /hotel-service/rooms/{id}        | Delete room by ID       |                                                     |

### Reservation Service

| Method | Endpoint                     | Description                  | Example Payload                                      |
|--------|------------------------------|------------------------------|-----------------------------------------------------|
| GET    | /reservation-service          | Get user's reservations      |                                                     |
| POST   | /reservation-service          | Create new reservation       | `{ "hotelId": 1, "roomId": 1, "checkInDate": "2025-07-10", "checkOutDate": "2025-07-15" }` (guestName from JWT) |
| GET    | /reservation-service/{id}     | Get reservation by ID        |                                                     |
| DELETE | /reservation-service/{id}     | Delete reservation by ID     |                                                     |

---

## Using Postman

- Import the Postman Collection file.
- Import and activate the attached environment file into Postman.    
- First run Auth Service - Get Token request to set the token variable.  
- Add `Authorization: Bearer {{token}}` header to other requests.  
- All requests go through API Gateway on port 8080.

---

## Error Handling

- Validation errors return `400 Bad Request` with details in JSON.  
- Unauthorized access returns `401` or `403`.  
- Overlapping reservation dates return an appropriate error message.

---

## Development Notes

- PostgreSQL is used as the database.  
- Kafka is used for event-driven architecture.  
- Docker Compose starts all services and dependencies (Kafka, Zookeeper, Postgres).  
- JWT Authentication secures the services.  
- Unit and integration tests are prepared separately.

---

> **Note:** Docker must be installed and running for the project to work properly.
