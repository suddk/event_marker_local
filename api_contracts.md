✅ Got it. Since we’ve agreed to consolidate everything into **one single file** for reference, here’s the latest **`api_contracts.md`** file. This will serve as the *source of truth* during the development cycle, so we don’t have to keep juggling scattered definitions.

---

# `api_contracts.md`

```markdown
# Event Marker – API Contracts

This document defines the API contracts for the Event Marker app.  
It serves as the single source of truth for backend–frontend communication.  

All endpoints are prefixed with:
```

/api/v1

````

---

## 1. Authentication

### 1.1 Register
**POST** `/api/v1/auth/register`

**Request**
```json
{
  "phone": "+91XXXXXXXXXX",
  "password": "securePassword"
}
````

**Response**

```json
{
  "userId": "u12345",
  "message": "User registered successfully"
}
```

---

### 1.2 Login

**POST** `/api/v1/auth/login`

**Request**

```json
{
  "phone": "+91XXXXXXXXXX",
  "password": "securePassword"
}
```

**Response**

```json
{
  "token": "jwt_token_here",
  "user": {
    "id": "u12345",
    "phone": "+91XXXXXXXXXX"
  }
}
```

---

## 2. Groups

### 2.1 Create Group

**POST** `/api/v1/groups`

**Request**

```json
{
  "name": "Weekend Trips",
  "description": "Friends group for trips",
  "createdBy": "u12345"
}
```

**Response**

```json
{
  "groupId": "g67890",
  "message": "Group created successfully"
}
```

---

### 2.2 Get My Groups

**GET** `/api/v1/groups?userId=u12345`

**Response**

```json
[
  {
    "groupId": "g67890",
    "name": "Weekend Trips",
    "description": "Friends group for trips"
  }
]
```

---

### 2.3 Delete Group

**DELETE** `/api/v1/groups/{groupId}`

**Response**

```json
{
  "message": "Group deleted successfully"
}
```

---

## 3. Events

### 3.1 Create Event

**POST** `/api/v1/events`

**Request**

```json
{
  "groupId": "g67890",
  "title": "Goa Trip",
  "date": "2025-09-10",
  "imageUrl": "https://example.com/trip.png",
  "createdBy": "u12345"
}
```

**Response**

```json
{
  "eventId": "e11223",
  "message": "Event created successfully"
}
```

---

### 3.2 Get Group Events

**GET** `/api/v1/events?groupId=g67890`

**Response**

```json
[
  {
    "eventId": "e11223",
    "title": "Goa Trip",
    "date": "2025-09-10",
    "imageUrl": "https://example.com/trip.png"
  }
]
```

---

### 3.3 Delete Event

**DELETE** `/api/v1/events/{eventId}`

**Response**

```json
{
  "message": "Event deleted successfully"
}
```

---

## 4. Group Join Requests

### 4.1 Send Join Request

**POST** `/api/v1/groups/{groupId}/join`

**Request**

```json
{
  "userId": "u22222"
}
```

**Response**

```json
{
  "message": "Join request sent successfully"
}
```

---

### 4.2 Get Pending Join Requests (Admin Only)

**GET** `/api/v1/groups/{groupId}/requests`

**Response**

```json
[
  {
    "requestId": "r999",
    "userId": "u22222",
    "status": "PENDING"
  }
]
```

---

### 4.3 Approve/Reject Join Request

**POST** `/api/v1/groups/{groupId}/requests/{requestId}`

**Request**

```json
{
  "status": "APPROVED" // or "REJECTED"
}
```

**Response**

```json
{
  "message": "Join request updated"
}
```

---

## 5. Archiving

### 5.1 Archive Event

**POST** `/api/v1/events/{eventId}/archive`

**Response**

```json
{
  "message": "Event archived successfully"
}
```

---

## 6. Data Export

### 6.1 Export Events (Excel/PDF)

**GET** `/api/v1/events/export?groupId=g67890&format=excel`

**Response**

* Returns a file (Excel/PDF) for download.

---

# Notes

* All authenticated routes require a Bearer JWT token.
* Dates follow `YYYY-MM-DD` format.
* Errors follow this schema:

```json
{
  "error": "Invalid request",
  "details": "Password must be at least 6 characters"
}
```

```

---

This is the **latest master version** of our API contracts.  
From now, whenever we add/modify endpoints, I’ll update this single file.  

Do you want me to **save this file into your project root (`docs/api_contracts.md`)** right away so we can lock it in for reference?
```
