# Human Heal 🩺

**Human Heal** is a Flutter-based mobile application designed to streamline healthcare access and user interactions.  
It provides features such as user authentication, password reset with OTP verification, and integration with Razorpay for secure payments.

---

## 📱 Features

- **User Authentication**
  - Login & Registration
  - Forgot Password with OTP verification
  - Secure password reset flow

- **OTP Verification**
  - Resend OTP option
  - Automatic countdown timer for OTP entry

- **Payments**
  - Razorpay integration for secure transactions

- **User-Friendly Interface**
  - Responsive design
  - Smooth navigation using GetX

---

## 🛠 Tech Stack

- **Flutter** (Cross-platform UI)
- **GetX** (State management & routing)
- **Razorpay SDK** (Payment integration)
- **REST API** (Backend communication)

---

## 📦 Installation & Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/human_heal.git
   cd human_heal


Install dependencies

flutter pub get
Configure Razorpay

Add your Razorpay API key in the appropriate config file or environment variable.

Run the app

flutter run
📂 Project Structure

human_heal/
│
├── lib/
│   ├── app/
│   │   ├── data/           # Models, API data handling
│   │   ├── services/       # API & storage services
│   │   ├── routes/         # App route definitions
│   │   └── modules/        # UI screens & controllers
│   │
│   └── main.dart           # App entry point
│
├── android/                # Android-specific code & configs
├── ios/                    # iOS-specific code & configs
└── pubspec.yaml            # Dependencies & assets
🔐 Environment Variables
Make sure to configure:

Razorpay API Key

Backend API base URL

🚀 Building for Release
Android:

flutter build apk --release

iOS:

flutter build ios --release

Note: For Razorpay, ensure you have the required ProGuard rules to avoid R8 build errors.

📄 License
This project is licensed under the MIT License — see the LICENSE file for details.

👨‍💻 Author
Developed by [Sahil khan]
📧 Contact: sahilkh3014@gmail.com


If you want, I can **also add screenshots & a project workflow diagram** in the README so it looks like a professional GitHub portfolio project. That would make it more appealing for clients or employers.  

Do you want me to prepare that enhanced version?
