# Healthcare Appointment App

## Overview
A complete healthcare appointment booking application built with Flutter, featuring a modern purple gradient UI design and comprehensive navigation system.

## Features

### 🏠 Home Screen
- **Doctor Categories**: Filter doctors by specialty (All, General, Cardiology, Dermatology, Orthopedic, Pediatrics)
- **Doctor Listings**: Browse available doctors with ratings and experience
- **Upcoming Appointments**: View next scheduled appointments
- **Quick Navigation**: Access to all main features

### 📅 Appointments Screen
- **Upcoming Appointments**: View scheduled appointments with doctor details
- **Past Appointments**: Review completed appointments history
- **Appointment Management**: Cancel or reschedule appointments
- **Tab Interface**: Easy switching between upcoming and past appointments

### 💬 Chat Screen
- **AI Health Assistant**: Interactive chat with health-related guidance
- **Quick Replies**: Pre-defined common health questions
- **Message History**: Conversation tracking
- **Smart Responses**: Contextual health advice

### 👤 Profile Screen
- **User Profile**: Personal information and health stats
- **Health Metrics**: Appointments, health score, and achievements
- **Settings**: App preferences and account management
- **Edit Profile**: Update personal information

### 👩‍⚕️ Doctor Detail Screen
- **Doctor Information**: Complete profile with specialization and experience
- **Date Selection**: Choose appointment date from available slots
- **Time Selection**: Pick preferred time slots
- **Booking Confirmation**: Secure appointment booking

### 🎨 Onboarding Screen
- **Welcome Interface**: Professional healthcare branding
- **Doctor Character**: Custom illustrated healthcare professional
- **Smooth Navigation**: Seamless entry to main app

## Technical Architecture

### Core Components
- **Healthcare Models**: `Doctor`, `Appointment`, `AppointmentCategory` classes
- **Healthcare Service**: Centralized business logic and data management
- **Navigation System**: Complete bottom navigation with 4 main screens
- **UI Theme**: Purple gradient design (#7B68EE) with modern aesthetics

### Key Screens
```
lib/screens/healthcare/
├── healthcare_onboarding_screen.dart    # Welcome screen
├── healthcare_home_screen.dart          # Main dashboard
├── doctor_detail_screen.dart            # Doctor profile & booking
├── appointments_screen.dart             # Appointment management
├── chat_screen.dart                     # Health assistant chat
└── profile_screen.dart                  # User profile & settings
```

### Services & Models
```
lib/models/healthcare_models.dart        # Data models
lib/services/healthcare_service.dart     # Business logic
```

## Navigation Flow
1. **Onboarding** → Welcome users with healthcare branding
2. **Home** → Browse doctors and view appointments
3. **Doctor Detail** → Select and book appointments
4. **Appointments** → Manage upcoming and past appointments
5. **Chat** → Get health assistance and advice
6. **Profile** → Manage account and view health metrics

## Features Implemented
✅ Complete UI matching design requirements  
✅ Doctor category filtering and selection  
✅ Appointment booking system  
✅ Appointment management (cancel/reschedule)  
✅ AI chat assistant with health guidance  
✅ User profile with health metrics  
✅ Full navigation between all screens  
✅ Modern purple gradient theme  
✅ Responsive design and smooth animations  

## Usage Instructions
1. **Launch App**: Start with onboarding screen
2. **Browse Doctors**: Use home screen to filter and select doctors
3. **Book Appointment**: Choose date/time and confirm booking
4. **Manage Appointments**: View and modify appointments in dedicated screen
5. **Chat Assistant**: Get health advice through AI chat
6. **Profile Management**: Update personal information and view metrics

## Navigation Bar
- **Home**: Main dashboard with doctors and appointments
- **Appointments**: Dedicated appointment management
- **Chat**: Health assistant and guidance
- **Profile**: Personal settings and health metrics

The app provides a complete healthcare solution with intuitive navigation and comprehensive functionality for managing healthcare appointments and interactions.
