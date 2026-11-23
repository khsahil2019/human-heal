# Human Heal - Bug Fixes & Improvements Task List

## 1. Platform & Build Stability
- [x] **Task 1.1: Fix Android Release Build Crash (`android/app/build.gradle.kts`)**
  - Added safe guard checking `if (keystorePropertiesFile.exists())` so Gradle doesn't throw NullPointerException when `key.properties` is missing, falling back to debug signing.
- [x] **Task 1.2: Add iOS Usage Descriptions (`ios/Runner/Info.plist`)**
  - Added `NSPhotoLibraryUsageDescription` and `NSCameraUsageDescription` to prevent SIGABRT crashes when picking profile images.

## 2. Authentication & Sign In / Sign Up Fixes
- [x] **Task 2.1: Fix Input Erasing Bug in Sign Up Screen (`signup_screen.dart`)**
  - Converted `SignUpScreen` to `StatefulWidget` and moved `clearSignupFields()` to `initState()` so typing/keyboard popup doesn't wipe user input.
- [x] **Task 2.2: Add Form Validation in Login Screen (`login_screen.dart`)**
  - Converted `LoginScreen` to `StatefulWidget`, added `Form` with validation key, and added proper email/password format validators.
- [x] **Task 2.3: Fix Type Mismatch & Response Parsing (`auth_controller.dart`)**
  - Updated `login()`, `register()`, and `verifyOtp()` to support both string `"1"` and integer `1` for `status`, and safely extract `userId`, `token`, and `verifiedStatus` across various response structures.
  - Set dynamic `device_type` (`iOS` / `Android`).
- [x] **Task 2.4: Fix OTP Verification Arguments & Display (`otp_verification_signup_screen.dart`)**
  - Fixed phone number display check (`phoneNumber.trim().isNotEmpty` instead of `phoneNumber == " "`).
  - Passed user mobile number from login flow to OTP verification.
- [x] **Task 2.5: Enhance API Service with Timeouts & Network Diagnostics (`api_service.dart`)**
  - Added 15-second timeout to prevent infinite loading spinners.
  - Added explicit network diagnostic messages (e.g. server unreachable vs timeout) so host resolution errors are clearly surfaced.

## 3. Runtime, Network & Payment Fixes
- [x] **Task 3.1: Fix Infinite API Fetch Loop (`doctor_list_screen.dart`)**
  - Converted `DoctorListScreen` to `StatefulWidget` and moved `fetchDoctors()` to `initState()` to prevent non-stop calls on every frame in `build()`.
- [x] **Task 3.2: Fix Wallet & Razorpay Auth Token Handling (`add_amount_screen.dart`)**
  - Switched to `TokenStorage.getToken()` and `AppConstants.baseUrl` so wallet payment order creation and keys fetching have valid authentication.
- [x] **Task 3.3: Fix Logout Token Leak (`profile_controller.dart`)**
  - Added `await TokenStorage.clearToken()` to `logout()` and `deleteAccount()` methods alongside `UserStorage.clearUser()`.
- [x] **Task 3.4: Fix Lab Test Order ID Type Crash (`lab_test_controller.dart`)**
  - Safely cast `order_id` to string using `.toString()` to avoid int-to-String type crashes.

## 4. UI, Navigation & Memory Fixes
- [x] **Task 4.1: Fix Post-Password Change Navigation (`auth_controller.dart`)**
  - Updated `mainController.changeTab(4)` so users are directed to Profile (index 4) instead of Wallet (index 3).
- [x] **Task 4.2: Fix Memory Leaks in Book Appointment Screen (`book_appointment.dart`)**
  - Implemented `dispose()` method in `_BookAppointmentScreenState` to dispose all 5 `TextEditingController` instances.
- [x] **Task 4.3: Implement Account Deletion Feature (`delete_account_screen.dart` & `profile_screen.dart`)**
  - Implemented full `DeleteAccountScreen` and linked it from `ProfileScreen` with two-step confirmation, complying with Google Play & Apple App Store account deletion requirements.

## 5. Code Cleanup & Verification
- [x] **Task 5.1: Clean Empty Files & Dead Code**
  - Implemented `app_theme.dart`, `auth_binding.dart`, `home_binding.dart`, and removed dead empty files (`logout_screen.dart`, `referred_by_screen.dart`, `home_controller.dart`, `user_prefs.dart`).
- [x] **Task 5.2: Update Smoke Test (`test/widget_test.dart`)**
  - Replaced obsolete counter boilerplate test with valid `HumanHealApp` smoke test.
- [x] **Task 5.3: Verify with `dart analyze`**
  - Verified 0 compilation errors across the entire codebase.

## 6. Backend Server URL & API Configuration
- [x] **Task 6.1: Update `AppConstants.baseUrl`**
  - Updated `AppConstants.baseUrl` from dead `demo4.in` to `https://humanhealhealthcare.com/app/api`.
- [x] **Task 6.2: Live API Endpoint Testing**
  - Ran automated test suite against all 26 mobile endpoints on `https://humanhealhealthcare.com/app/api`.
  - Confirmed all routes are registered and mapped in Laravel `routes/api.php`.
  - Identified backend PHP FatalError preventing all API responses:
    `Cannot declare class App\Http\Controllers\Api because the name is already in use at /home/u519152088/domains/humanhealhealthcare.com/public_html/app/app/Http/Controllers/Api.php line 24`.

## 7. Backend Action & Status Updates
- [x] **Backend Class Name Conflict Fixed (`Api.php`)**:
  - The duplicate class declaration error on Hostinger server is RESOLVED. Live endpoints now return proper JSON.
- [ ] **Database Migration for Razorpay Gateways & Orders**:
  - `GET /get-payment-keys` returned SQL Error: `tbl_payment_gateways` table missing.
  - `POST /create-order` returned SQL Error: `tbl_create_orders` table missing.
  - Backend database admin needs to run migrations or create these two tables.
- [ ] **Add missing `api/delete-account` route to `routes/api.php`**.

## 8. Build & Device Deployment
- [x] **Task 8.1: Build APK & Run on Attached Device**
  - Generated APK at `build/app/outputs/flutter-apk/app-debug.apk`.
  - Installed and launched successfully on attached device (CPH2469, Android 14, PID: 18977).
- [x] **Task 8.2: Comprehensive Postman API Testing (27 Endpoints)**
  - Tested all 27 Postman collection APIs against live production server `https://humanhealhealthcare.com/app/api`:
  - 25 APIs returned HTTP 200 OK with valid payloads.
  - 2 APIs returned HTTP 500 due to missing MySQL tables (`tbl_payment_gateways`, `tbl_create_orders`).
- [x] **Task 8.3: Flutter API Implementation & Hardening**
  - `ProfileController`: Added server-side `POST /logout` call, replaced raw snackbars with `safeSnackbar()`.
  - `ReferralController`: Replaced raw snackbars with `safeSnackbar()`.
  - `PasswordController`: Replaced raw snackbars with `safeSnackbar()`, confirmed 10-digit number handling.
  - `WalletController`: Implemented `addMoneyToWallet()` matching Postman parameter schema (`user_id, amount, order_id, payment_id, signature`).
  - `WalletModel`: Hardened `TransactionModel.fromJson` against null fields and date parsing exceptions.
  - `android/app/build.gradle.kts`: Bumped `compileSdk` to 36 to satisfy plugin requirements.
