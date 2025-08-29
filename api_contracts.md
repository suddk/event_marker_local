
# API Contracts – Event Marker (Clean Spec)

**Base URL prefix:** `/api/v1`  
**Auth:** All protected routes require `Authorization: Bearer <jwt>`  
**Dates:** ISO 8601 timestamps (e.g., `2025-09-10T00:00:00Z`).  
**IDs:** Use `"id"` in payloads. (Avoid mixing `groupId`, `eventId`; the client can map as needed.)

## Global Error Schema
```json
{
  "error": {
    "code": "STRING_CODE",
    "message": "Human-readable message"
  }
}
```

---

## 1. Authentication

### 1.1 Register
- **Endpoint**: `POST /api/v1/auth/register`
- **Request**
```json
{
  "phone": "9876543210",
  "password": "securePass123"
}
```
- **Response**
```json
{
  "id": "u12345",
  "message": "User registered successfully"
}
```

### 1.2 Login
- **Endpoint**: `POST /api/v1/auth/login`
- **Request**
```json
{
  "phone": "9876543210",
  "password": "securePass123"
}
```
- **Response**
```json
{
  "token": "jwt-token-xyz",
  "user": {
    "id": "u12345",
    "phone": "9876543210"
  }
}
```

> **Note:** Profile fields (e.g., name, avatar) are *not* part of auth. Add a separate profile endpoint later if needed.

---

## 2. Users (for member picker)

### 2.1 List Users
- **Endpoint**: `GET /api/v1/users?query={q}`
- **Response**
```json
[
  { "id": "u1", "name": "Alice", "phone": "9990001111" },
  { "id": "u2", "name": "Bob",   "phone": "9990002222" }
]
```

---

## 3. Groups

### 3.1 Create Group
- **Endpoint**: `POST /api/v1/groups`
- **Request**
```json
{
  "name": "Weekend Trips",
  "description": "Friends group for trips",
  "createdBy": "u12345",
  "memberIds": ["u12345", "u99999"]
}
```
- **Response**
```json
{
  "id": "g67890",
  "name": "Weekend Trips",
  "description": "Friends group for trips",
  "createdBy": "u12345",
  "memberIds": ["u12345", "u99999"],
  "createdAt": "2025-08-22T18:30:00Z"
}
```

### 3.2 Update Group (Admin only)
- **Endpoint**: `PUT /api/v1/groups/{groupId}`
- **Request**
```json
{
  "name": "Weekend Trips Renamed",
  "description": "Updated description",
  "memberIds": ["u12345", "u99999", "u77777"]
}
```
- **Response**
```json
{
  "id": "g67890",
  "name": "Weekend Trips Renamed",
  "description": "Updated description",
  "createdBy": "u12345",
  "memberIds": ["u12345", "u99999", "u77777"],
  "updatedAt": "2025-08-22T18:35:00Z"
}
```

### 3.3 List My Groups
- **Endpoint**: `GET /api/v1/groups?userId={userId}`
- **Response**
```json
[
  {
    "id": "g67890",
    "name": "Weekend Trips",
    "description": "Friends group for trips",
    "createdBy": "u12345",
    "memberIds": ["u12345", "u99999"]
  }
]
```

### 3.4 Delete Group (Admin only; cascade events)
- **Endpoint**: `DELETE /api/v1/groups/{groupId}`
- **Response**
```json
{ "success": true }
```

### 3.5 Group Members (explicit ops, optional if you prefer 3.1/3.2 bulk memberIds)
- **Add Members**: `POST /api/v1/groups/{groupId}/members`
  - **Request**
  ```json
  { "userIds": ["u77777", "u88888"] }
  ```
  - **Response**
  ```json
  {
    "id": "g67890",
    "memberIds": ["u12345", "u99999", "u77777", "u88888"]
  }
  ```

- **Remove Member**: `DELETE /api/v1/groups/{groupId}/members/{userId}`
  - **Response**
  ```json
  { "success": true }
  ```

---

## 4. Join Requests

### 4.1 Send Join Request
- **Endpoint**: `POST /api/v1/groups/{groupId}/requests`
- **Request**
```json
{ "userId": "u22222" }
```
- **Response**
```json
{
  "id": "r999",
  "groupId": "g67890",
  "userId": "u22222",
  "status": "PENDING",
  "createdAt": "2025-08-22T18:31:00Z"
}
```

### 4.2 List Pending Requests (Admin)
- **Endpoint**: `GET /api/v1/groups/{groupId}/requests?status=PENDING`
- **Response**
```json
[
  { "id": "r999", "userId": "u22222", "status": "PENDING" }
]
```

### 4.3 Approve/Reject Request (Admin)
- **Endpoint**: `PUT /api/v1/groups/{groupId}/requests/{requestId}`
- **Request**
```json
{ "status": "APPROVED" }
```
- **Response**
```json
{ "id": "r999", "status": "APPROVED" }
```

---

## 5. Events

### 5.1 Create Event
- **Endpoint**: `POST /api/v1/groups/{groupId}/events`
- **Request**
```json
{
  "title": "Goa Trip",
  "description": "3-day trip",
  "date": "2025-09-10T00:00:00Z",
  "createdBy": "u12345",
  "imageUrl": "https://example.com/trip.png"
}
```
- **Response**
```json
{
  "id": "e11223",
  "groupId": "g67890",
  "title": "Goa Trip",
  "description": "3-day trip",
  "date": "2025-09-10T00:00:00Z",
  "createdBy": "u12345",
  "imageUrl": "https://example.com/trip.png",
  "createdAt": "2025-08-22T18:40:00Z"
}
```

### 5.2 List Group Events
- **Endpoint**: `GET /api/v1/groups/{groupId}/events`
- **Response**
```json
[
  {
    "id": "e11223",
    "groupId": "g67890",
    "title": "Goa Trip",
    "date": "2025-09-10T00:00:00Z",
    "imageUrl": "https://example.com/trip.png"
  }
]
```

### 5.3 Delete Event
- **Endpoint**: `DELETE /api/v1/events/{eventId}`
- **Response**
```json
{ "success": true }
```

### 5.4 Archive Event
- **Endpoint**: `POST /api/v1/events/{eventId}/archive`
- **Response**
```json
{ "success": true }
```

---

## 6. Export

### 6.1 Export Events
- **Endpoint**: `GET /api/v1/groups/{groupId}/events/export?format=excel|pdf`
- **Response**
- File download (`application/vnd.openxmlformats-officedocument.spreadsheetml.sheet` or `application/pdf`)
