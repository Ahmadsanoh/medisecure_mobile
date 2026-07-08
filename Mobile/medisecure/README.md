# MediSecure

MediSecure is a healthcare management platform designed to provide secure and efficient digital healthcare services. The system connects patients, healthcare professionals, and administrators through a modern web and mobile ecosystem.

The project includes:

- A **Django backend API** responsible for authentication, medical data management, appointments, and healthcare services.
- A **Flutter mobile application** providing users with a secure and accessible interface.

---

# Features

## Backend (Django)

- User authentication and authorization
- JWT authentication
- User management
- Medical records management
- Appointment scheduling
- Healthcare data management
- PDF report generation
- Email services
- REST API integration
- Database management

## Mobile Application (Flutter)

- Secure user login
- Patient dashboard
- Medical information access
- Appointment management
- API communication with backend
- Mobile-friendly user interface

---

# Project Structure

```
MediSecure/
│
├── Medisecure/
│   ├── manage.py
│   ├── config/
│   ├── medisecure/
│   ├── medical/
│   ├── users/
│   └── .venv/
│
└── Mobile/
    └── medisecure/
        └── mobile/
            ├── android/
            ├── lib/
            ├── test/
            ├── pubspec.yaml
            └── README.md
```

---

# Requirements

## Backend Requirements

- Python 3.13+
- Django
- PostgreSQL
- uv package manager

## Mobile Requirements

- Flutter 3.38+
- Dart 3.10+
- Android Studio
- Android Emulator or physical device

---

# Backend Installation

Go to the backend directory:

```bash
cd MediSecure/Medisecure
```

Create the Python environment:

```bash
uv venv --python 3.13
```

Activate the environment:

### Windows PowerShell

```powershell
.venv\Scripts\activate
```

Install dependencies:

```bash
uv sync
```

Run database migrations:

```bash
python manage.py migrate
```

Start the Django server:

```bash
python manage.py runserver
```

Backend will be available at:

```
http://127.0.0.1:8000/
```

---

# Mobile Installation

Go to the Flutter application directory:

```bash
cd Mobile/medisecure/mobile
```

Install Flutter packages:

```bash
flutter pub get
```

Check available devices:

```bash
flutter devices
```

Run the mobile application:

```bash
flutter run
```

Run specifically on Android emulator:

```bash
flutter run -d emulator
```

---

# Environment Configuration

Create and configure environment files.

## Backend

Create:

```
.env
```

Configure:

- Database settings
- Secret keys
- Email configuration
- API configuration

## Mobile

Create:

```
Mobile/medisecure/mobile/.env
```

Configure:

- Backend API URL
- Application settings

---

# Running the Project

You need two terminals.

## Terminal 1 - Backend

```bash
cd MediSecure/Medisecure

.venv\Scripts\activate

python manage.py runserver
```

## Terminal 2 - Mobile App

```bash
cd Mobile/medisecure/mobile

flutter run
```

---

# Testing

## Django Backend Tests

Run:

```bash
python manage.py test
```

## Flutter Tests

Run:

```bash
flutter test
```

---

# Technologies Used

## Backend

- Python
- Django
- Django REST Framework
- PostgreSQL
- JWT Authentication
- Celery
- Redis
- ReportLab

## Mobile

- Flutter
- Dart
- Riverpod
- Go Router
- Flutter Secure Storage

---

# Development Notes

The backend provides REST APIs consumed by the Flutter mobile application.

The project uses:

- Secure authentication
- Environment-based configuration
- Database migrations
- Mobile API integration

---

# Troubleshooting

## Python Dependency Issues

Reinstall dependencies:

```bash
uv sync
```

## Flutter Dependency Issues

Run:

```bash
flutter clean
flutter pub get
```

## Database Migration Issues

Run:

```bash
python manage.py makemigrations
python manage.py migrate
```

---

# License

This project is developed for educational and software development purposes.