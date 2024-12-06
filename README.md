
# ThogaKade CLI Based Management System

This is a CLI-based management system for a shop called 'ThogaKade' based on Dart. This system allows users to navigate easily to features, perform CRUD operations for items, place orders, and more.

---
## Features
1. **Inventory Management**
- Add, remove, update and search vegetables.
- Alerts for low-stock vegetables and expired vegetables.

2. **Order Processing Management**
- Place orders including multiple items.
- Maintain a history of placed orders.

3. **Order Processing Management**
- Save and load inventory and orders using JSON files.
- Handles file I/O exceptions gracefully.

---

## Technologies Used

- **Programming Language**: Dart
- **Persistence**: JSON file storage

---

## Directory Structure

```
lib/ 
├── cli/ 
│   └── command_handler.dart # Handles CLI input/output 
├── managers/ 
│   ├── inventory_manager.dart # Manages inventory operations 
│   └── thoga_kade_manager.dart # Implements order management and other operations 
├── models/ 
│   ├── vegetable.dart # Vegetable model 
│   ├── order.dart # Order model 
│   └── report.dart # Report generation
├── repositories/ 
│   ├── inventory_repository.dart # Handles inventory persistence
│   └── order_repository.dart # Handles order persistence
├── services/ 
│   └── report_service.dart # Generates reports   
├── utils/ 
│   ├── validators.dart # Validation utilities
│   └── formatters.dart
```
---

## Installation and Setup
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/PrabathBnk/ThogaKade_CLI_Management_System.git
   cd thoga-kade
2. **Install Dart SDK:** Ensure you have Dart installed. [Install Dart](https://dart.dev/get-dart).
3. **Install Dependencies:** Run the following to install the required packages:
    ```bash
    dart pub get
4. **Run the Application:** Start the CLI application:
    ```bash
    dart run lib/main.dart
5. **Run Unit Tests:** To ensure the code works as expected, execute:
    ```bash
    dart test

---

## Known Limitations

- Single-User Mode: Does not support concurrent users.
- No Authentication: Any user can access all features.
