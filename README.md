# 📌 Pinterest Clone

A pixel-perfect Pinterest clone built with Flutter, featuring a beautiful Material 3 design, robust state management, and seamless user experience.

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.7.2+-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-3.7.2+-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Material_3-Enabled-6200EE?style=for-the-badge" alt="Material 3" />
</p>

## ✨ Features

### 🏠 Core Functionality
- **Curated Photo Feed** - Infinite scroll masonry grid with beautiful image loading
- **Smart Search** - Debounced search with trending topics and category suggestions
- **Pin Details** - Full-screen pin view with photographer info and similar recommendations
- **Save & Organize** - Save favorite pins and organize them into custom boards
- **Social Features** - Follow photographers and see their latest work
- **Upload Pins** - Upload and share your own photos from gallery
- **Profile Management** - Comprehensive profile with saved pins, boards, following, and uploads

### 🎨 Design & UX
- **Material 3 Design** - Modern, polished UI following Material Design 3 guidelines
- **Dark/Light Themes** - Seamless theme switching with Pinterest brand colors
- **Smooth Animations** - Hero transitions, fade-ins, and press animations
- **Shimmer Loading** - Beautiful skeleton screens while content loads
- **Pull-to-Refresh** - Custom Pinterest-style refresh indicator with logo animation
- **Responsive Grid** - Adaptive masonry layout for optimal image display

### 🔐 Authentication & Security
- **Clerk Authentication** - Secure, modern authentication flow
- **Session Management** - Automatic auth state synchronization
- **Protected Routes** - Auth-aware navigation with automatic redirects

### ⚡ Performance
- **Image Caching** - Multi-tier caching strategy (thumbnails + full images)
- **Lazy Loading** - Efficient infinite scroll with pagination
- **Optimized Rendering** - RepaintBoundary and cached widgets
- **Network Optimization** - Dio-based HTTP client with interceptors

## 🏗️ Architecture

This project follows **Clean Architecture** principles with a feature-based organization:

```
lib/
├── app/                      # App root & configuration
│   ├── app.dart             # Root widget with theme & routing
│   └── theme_provider.dart  # Theme state management
│
├── core/                     # Shared resources
│   ├── constants/           # App-wide constants
│   ├── router/              # Navigation configuration
│   ├── theme/               # Design system (colors, typography, spacing)
│   └── widgets/             # Reusable components
│
├── features/                 # Feature modules
│   ├── auth/                # Authentication
│   │   ├── data/           # Data sources & repositories
│   │   ├── domain/         # Entities & contracts
│   │   └── presentation/   # UI & state management
│   │
│   ├── home/                # Home feed
│   ├── search/              # Search functionality
│   ├── pin/                 # Pin details & interactions
│   ├── profile/             # User profile
│   └── inbox/               # Messages & updates (UI only)
│
└── services/                 # Infrastructure services
    ├── network_service.dart # Dio HTTP client
    └── cache_service.dart   # Image caching
```

### State Management

- **Riverpod** - Type-safe, testable state management
- **StateNotifier** - For complex state with business logic
- **AsyncValue** - Built-in loading/error handling
- **Provider Scope** - Dependency injection

### Data Flow

```
Presentation Layer (UI)
    ↓
StateNotifier (Business Logic)
    ↓
Repository (Abstraction)
    ↓
DataSource (API/Local Storage)
```

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK** - Version 3.7.2 or higher
- **Dart SDK** - Version 3.7.2 or higher
- **Pexels API Key** - Free API key from [Pexels](https://www.pexels.com/api/)
- **Clerk Account** - Free account from [Clerk](https://clerk.com/)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/pinterest-clone.git
   cd pinterest-clone
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**
   
   Create a `.env` file in the root directory:
   ```env
   PEXELS_API_KEY=your_pexels_api_key_here
   CLERK_PUBLISHABLE_KEY=your_clerk_publishable_key_here
   ```

   **How to get API keys:**
   
   - **Pexels API Key**:
     1. Visit [Pexels API](https://www.pexels.com/api/)
     2. Sign up for a free account
     3. Generate your API key from the dashboard
   
   - **Clerk Publishable Key**:
     1. Sign up at [Clerk.com](https://clerk.com/)
     2. Create a new application
     3. Copy the publishable key from the dashboard

4. **Run the app**
   ```bash
   flutter run
   ```

### Building for Production

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

## 📦 Dependencies

### Core
- `flutter_riverpod` ^2.6.1 - State management
- `go_router` ^14.8.1 - Declarative routing
- `dio` ^5.7.0 - HTTP client

### UI & Design
- `google_fonts` ^6.2.1 - Custom typography (Inter font)
- `shimmer` ^3.0.0 - Loading placeholders
- `flutter_staggered_grid_view` ^0.7.0 - Masonry layout
- `cached_network_image` ^3.4.1 - Optimized image loading

### Authentication & Storage
- `clerk_flutter` 0.0.14-beta - Authentication
- `shared_preferences` ^2.3.4 - Local key-value storage
- `flutter_cache_manager` ^3.4.1 - Advanced caching

### Utilities
- `flutter_dotenv` ^5.2.1 - Environment configuration
- `image_picker` ^1.1.2 - Gallery access
- `share_plus` ^10.1.4 - Native sharing
- `url_launcher` ^6.3.1 - External links

## 🎨 Design System

### Color Palette
- **Primary**: Pinterest Red (`#E60023`)
- **Light Theme**: Clean whites and subtle grays
- **Dark Theme**: Deep blacks with elevated surfaces

### Typography
- **Font Family**: Inter (via Google Fonts)
- **Scales**: Display, Headline, Title, Body, Label
- **Weights**: 400 (Regular), 500 (Medium), 600 (SemiBold), 700 (Bold), 800 (ExtraBold)

### Spacing System
4px grid system:
- `xs` (4px), `sm` (8px), `md` (12px), `lg` (16px)
- `xl` (20px), `xxl` (24px), `xxxl` (32px), `xxxxl` (48px)

### Border Radius
- Small: 8px
- Medium: 16px (pins, cards)
- Large: 24px
- XL: 32px
- Full: 999px (pills)

## 🔧 Configuration

### Network Service
Located in `lib/services/network_service.dart`

- Base URL: Pexels API v1
- Timeouts: Connect (10s), Receive (15s), Send (10s)
- Auto-retry with exponential backoff
- Debug logging interceptor

### Cache Service
Located in `lib/services/cache_service.dart`

Two-tier caching strategy:
- **Thumbnails**: 200 objects, 7-day stale period
- **Full Images**: 50 objects, 3-day stale period
- Memory cache: 100MB, 200 images

## 📱 Screens Overview

### 1. Authentication (`/login`)
- Clerk-powered authentication
- Pinterest-branded login screen
- Automatic session management

### 2. Home Feed (`/`)
- **For You Tab**: Curated photo feed from Pexels
- **Saved Tab**: User's saved/liked pins
- Infinite scroll with pagination
- Pull-to-refresh functionality
- Press animations on pin cards

### 3. Search (`/search`)
- Debounced search input (400ms)
- Trending carousel with hero images
- Featured boards section
- Category chips grid
- Search results with masonry layout

### 4. Pin Detail (`/pin/:id`)
- Full-screen image with hero transition
- Photographer information
- Follow/Unfollow functionality
- Save/Heart button
- Share and visit options
- "More like this" recommendations grid

### 5. Inbox (`/inbox`)
- Messages section (UI only)
- Updates feed with suggestions
- Pinterest-style notifications

### 6. Profile (`/profile`)
- User avatar and stats
- **Four tabs**:
  - **Saved**: All saved pins
  - **Boards**: Custom pin collections
  - **Following**: Followed photographers
  - **Uploads**: User-uploaded pins
- Theme toggle (Light/Dark)
- Sign out functionality

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## 📂 Project Structure Details

### Feature Modules

Each feature follows a consistent structure:

```
feature/
├── data/
│   ├── datasources/     # API clients, local storage
│   ├── models/          # Data transfer objects
│   └── repositories/    # Repository implementations
├── domain/
│   ├── entities/        # Business objects
│   └── repositories/    # Repository contracts
└── presentation/
    ├── providers/       # State management
    ├── screens/         # Full-page views
    └── widgets/         # Feature-specific components
```

### Key Files

- `main.dart` - App entry point, service initialization
- `app/app.dart` - Root widget with theming and routing
- `core/router/app_router.dart` - Route configuration
- `core/theme/app_theme.dart` - Material 3 theme definitions

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused
- Write tests for new features

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **[Pexels](https://www.pexels.com/)** - Free stock photos API
- **[Clerk](https://clerk.com/)** - Authentication infrastructure
- **[Flutter](https://flutter.dev/)** - UI framework
- **Pinterest** - Design inspiration

## 📞 Support

If you have any questions or run into issues:

- Open an [issue](https://github.com/yourusername/pinterest-clone/issues)
- Check the [documentation](https://docs.flutter.dev/)
- Review the [Pexels API docs](https://www.pexels.com/api/documentation/)
- Visit [Clerk documentation](https://clerk.com/docs)

## 🗺️ Roadmap

### Planned Features
- [ ] Real-time messaging in Inbox
- [ ] Board collaboration
- [ ] Pin comments
- [ ] Advanced search filters
- [ ] Video pin support
- [ ] Analytics dashboard
- [ ] Push notifications
- [ ] Offline mode
- [ ] Web platform support

---

<p align="center">
  Made with ❤️ and Flutter
</p>

<p align="center">
  <a href="#-pinterest-clone">Back to top ↑</a>
</p>
