# Krishi Mitra 🌾

A comprehensive Flutter application for farmers providing crop disease diagnosis, market prices, weather information, and agricultural insights.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Tech Stack](#tech-stack)
- [Getting Started](#getting-started)
- [API Integration](#api-integration)
- [State Management](#state-management)
- [Authentication Flow](#authentication-flow)
- [Crop Diagnosis Flow](#crop-diagnosis-flow)
- [Contributing](#contributing)

## 🌟 Overview

Krishi Mitra is a mobile application designed to empower farmers with technology-driven solutions for crop management, disease detection, and market intelligence. The app uses AI-powered image analysis to diagnose crop diseases and provides actionable remedies.

## ✨ Features

### 1. Authentication
- Phone number-based OTP authentication
- JWT token management with automatic refresh
- Secure token storage using Flutter Secure Storage
- Profile completion and management

### 2. Crop Disease Diagnosis
- Camera/gallery image capture
- AI-powered disease detection
- Confidence score reporting
- Treatment recommendations
- Historical submission tracking

### 3. Market Intelligence
- Real-time mandi prices
- Market price comparisons
- Crop price trends

### 4. Weather Information
- Location-based weather forecasts
- Agricultural weather insights

### 5. My Crops
- Crop portfolio management
- Submission history

## 🏗️ Architecture

Krishi Mitra follows **Clean Architecture** principles with **Feature-First** organization, ensuring scalability, testability, and maintainability.

### Architecture Layers

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│  (Screens, Widgets, UI Components)      │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│        Application Layer                │
│  (State Management, Notifiers,          │
│   Providers, Business Logic)            │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│           Domain Layer                  │
│  (Entities, DTOs, Exceptions,           │
│   Business Rules)                       │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│           Data Layer                    │
│  (Repositories, Services,               │
│   API Clients, Data Sources)            │
└─────────────────────────────────────────┘
```

### Design Patterns

- **Repository Pattern**: Abstracts data sources
- **Provider Pattern**: Dependency injection via Riverpod
- **State Management**: Riverpod StateNotifier
- **Interceptor Pattern**: JWT authentication and token refresh
- **DTO Pattern**: Data transfer objects for API communication

## 📁 Project Structure

```
lib/
├── core/                           # Core functionality shared across features
│   ├── api/                        # API clients and interceptors
│   │   ├── dio_client.dart         # Configured Dio instance with interceptors
│   │   └── refresh_token_interceptor.dart  # Automatic token refresh
│   ├── constant/                   # App-wide constants
│   │   ├── api_constants.dart      # API endpoints and base URLs
│   │   └── colors_theme.dart       # Theme colors
│   └── services/                   # Core services
│       ├── connectivity_service.dart    # Network connectivity checks
│       └── secure_storage_service.dart  # Secure token storage
│
├── features/                       # Feature modules (feature-first)
│   ├── 1_auth/                     # Authentication feature
│   │   ├── application/            # State management
│   │   │   ├── auth_notifier.dart
│   │   │   ├── auth_providers.dart
│   │   │   ├── auth_state.dart
│   │   │   ├── create_account/
│   │   │   └── otp_verification/
│   │   ├── data/                   # Data layer
│   │   │   ├── auth_repository.dart
│   │   │   └── auth_service.dart
│   │   ├── domain/                 # Domain models
│   │   │   ├── exceptions/
│   │   │   ├── login_response.dart
│   │   │   ├── user_profile_update_request.dart
│   │   │   └── verify_otp_request.dart
│   │   └── presentation/           # UI layer
│   │       ├── screens/
│   │       └── widgets/
│   │
│   ├── 2_home/                     # Home dashboard feature
│   │   ├── application/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── 3_crop_diagnosis/           # Crop disease diagnosis feature
│       ├── application/            # State management
│       │   ├── crop_analysis_notifier.dart
│       │   ├── crop_analysis_providers.dart
│       │   └── crop_analysis_state.dart
│       ├── data/                   # Data layer
│       │   └── crop_repository.dart
│       ├── domain/                 # Domain models
│       │   ├── exceptions/
│       │   ├── confirm_upload_response_dto.dart
│       │   ├── crop_submission_response_dto.dart
│       │   └── presigned_url_dto.dart
│       └── presentation/           # UI layer
│           ├── screens/
│           │   ├── crop_upload_screen.dart
│           │   ├── processing_screen.dart
│           │   └── result_screen.dart
│           └── widgets/
│
├── routes/                         # Navigation
│   └── app_router.dart             # GoRouter configuration
│
├── shared/                         # Shared UI components
│   └── widgets/
│       ├── common_elevated_button.dart
│       └── common_text_widget.dart
│
└── main.dart                       # App entry point
```

## 🛠️ Tech Stack

### Core Framework
- **Flutter SDK**: ^3.9.0
- **Dart**: ^3.9.0

### State Management
- **flutter_riverpod**: ^2.6.1 - State management and dependency injection
- **hooks_riverpod**: ^2.6.1 - React-like hooks for Riverpod

### Navigation
- **go_router**: ^16.2.1 - Declarative routing with deep linking support

### Networking
- **dio**: ^5.9.0 - HTTP client with interceptor support
- **connectivity_plus**: ^6.1.2 - Network connectivity monitoring

### Authentication & Security
- **flutter_secure_storage**: ^9.2.4 - Secure token storage
- **jwt_decoder**: ^2.0.1 - JWT token parsing and validation

### UI/UX
- **google_fonts**: ^6.3.1 - Custom fonts
- **cached_network_image**: ^3.3.1 - Image caching
- **pinput**: ^5.0.2 - OTP input widget

### Media & Permissions
- **image_picker**: ^1.0.7 - Camera and gallery access
- **permission_handler**: ^11.3.0 - Runtime permissions

### Utilities
- **intl**: ^0.20.2 - Internationalization and date formatting
- **profanity_filter**: ^2.0.0 - Content moderation

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (^3.9.0)
- Dart SDK (^3.9.0)
- Android Studio / Xcode (for mobile development)
- An IDE (VS Code, Android Studio, or IntelliJ)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd krishi_mitra
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API endpoint**
   
   Update the base URL in `lib/core/constant/api_constants.dart`:
   ```dart
   static const String baseUrl = 'https://your-api-endpoint.com';
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Build for Production

**Android:**
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

## 🔌 API Integration

### Base Configuration

The app uses Dio for HTTP requests with custom interceptors for authentication and token refresh.

**Dio Client Setup** (`lib/core/api/dio_client.dart`):
```dart
- Base URL configuration
- Request/response interceptors
- JWT token injection
- Automatic token refresh on 401 errors
- Timeout configuration (10 seconds)
```

### Authentication Interceptor

**Flow:**
1. Checks if request is to a public endpoint (getOtp, verifyOtp)
2. For protected endpoints, retrieves access token from secure storage
3. Adds `Authorization: Bearer <token>` header
4. Continues with request

### Refresh Token Interceptor

**Flow:**
1. Intercepts 401 Unauthorized errors
2. Prevents refresh loops (doesn't refresh if refresh endpoint failed)
3. Queues concurrent requests during refresh
4. Attempts token refresh with stored refresh token
5. Retries original request with new token
6. Retries all queued requests
7. Triggers logout if refresh fails

### API Endpoints

**Authentication:**
- `GET /api/auth/getOtp/{phoneNumber}` - Request OTP
- `POST /api/auth/verifyOtp` - Verify OTP and get tokens
- `POST /api/auth/refresh?refreshToken={token}` - Refresh access token
- `POST /signUp/register` - Complete user profile

**Crop Diagnosis:**
- `GET /upload/presignedurl?fileName={name}` - Get S3 presigned URL
- `PUT <presigned-url>` - Upload image to S3
- `POST /upload/confirmUpload?objectKey={key}` - Confirm upload
- `GET /upload/processed/{submissionId}` - Get analysis results

## 🎯 State Management

### Riverpod Architecture

The app uses **Riverpod** for state management with the following provider types:

1. **Provider**: Immutable dependencies (services, repositories)
2. **StateNotifierProvider**: Mutable state with business logic
3. **FutureProvider**: Async data fetching
4. **StreamProvider**: Real-time data streams

### State Flow Example (Crop Diagnosis)

```
User Action (Upload Image)
        ↓
CropAnalysisNotifier.uploadAndAnalyze()
        ↓
CropRepository.getPresignedUrl()
        ↓
CropRepository.uploadImageToS3()
        ↓
CropRepository.confirmUpload()
        ↓
CropRepository.getProcessingResult() [Polling]
        ↓
State Update → UI Rebuild
```

## 🔐 Authentication Flow

### 1. Phone Number Input
```
User enters phone number
        ↓
Validation (10 digits, profanity check)
        ↓
POST /api/auth/getOtp/{phoneNumber}
        ↓
Navigate to OTP screen
```

### 2. OTP Verification
```
User enters 6-digit OTP
        ↓
POST /api/auth/verifyOtp
        ↓
Receive: accessToken, refreshToken, profileComplete
        ↓
Store tokens in secure storage
        ↓
If profileComplete: Navigate to Home
Else: Navigate to Create Account
```

### 3. Profile Completion
```
User fills profile details
        ↓
POST /signUp/register (with JWT)
        ↓
Update profileComplete status
        ↓
Navigate to Home
```

### 4. Token Refresh (Automatic)
```
API request returns 401
        ↓
RefreshTokenInterceptor intercepts
        ↓
POST /api/auth/refresh
        ↓
Store new tokens
        ↓
Retry original request
        ↓
If refresh fails: Logout user
```

## 🌾 Crop Diagnosis Flow

### Complete Workflow

```
1. Image Selection
   ├─ Camera capture
   └─ Gallery selection
        ↓
2. Get Presigned URL
   GET /upload/presignedurl?fileName={name}
   Response: { presignedUrl, objectKey }
        ↓
3. Upload to S3
   PUT {presignedUrl}
   Body: Image binary data
   Headers: Content-Type: image/jpeg
        ↓
4. Confirm Upload
   POST /upload/confirmUpload?objectKey={key}
   Response: { submissionId, status }
        ↓
5. Poll for Results (every 3 seconds, max 40 attempts)
   GET /upload/processed/{submissionId}
   Response: {
     submissionId,
     diseaseName,
     remedy,
     status,
     confidenceScore,
     imageUrl
   }
        ↓
6. Display Results
   Show disease name, confidence, remedy
```

### State Transitions

```
initial → selectingImage → imageSelected → gettingUrl 
→ uploadingToS3 → confirmingUpload → pollingResult 
→ completed (or error at any stage)
```

### Error Handling

Each step has specific error handling:
- **Network errors**: Connectivity checks before requests
- **Timeout errors**: 10-second timeout with retry suggestions
- **401/403 errors**: Automatic token refresh or re-authentication
- **404 errors**: Resource not found messages
- **500+ errors**: Server error messages
- **Type errors**: Safe JSON parsing with defaults

## 🧪 Testing

### Run Tests
```bash
flutter test
```

### Test Coverage
```bash
flutter test --coverage
```

## 📱 Supported Platforms

- ✅ Android (API 21+)
- ✅ iOS (iOS 12+)

## 🔒 Security Features

1. **Secure Token Storage**: Flutter Secure Storage for JWT tokens
2. **Automatic Token Refresh**: Seamless token renewal
3. **Request Encryption**: HTTPS for all API calls
4. **Input Validation**: Profanity filtering and format validation
5. **Permission Management**: Runtime permission requests

## 🐛 Known Issues & Fixes

### Recent Fixes

**Issue #1: 403 Forbidden on /upload/processed endpoint**
- **Cause**: Auth interceptor wasn't adding JWT to non-auth paths
- **Fix**: Updated interceptor logic to exclude only public endpoints

**Issue #2: Type casting error during JSON parsing**
- **Cause**: Unsafe type casting of response data
- **Fix**: Added defensive parsing with type checks and defaults

**Built with ❤️ for farmers using Flutter**
