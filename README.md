📸 **PhotoGalleryApp**

**PhotoGalleryApp is a SwiftUI-based iOS application that fetches photos from the [Picsum API](https://picsum.photos/) and provides a smooth user experience with features like splash screen animation, infinite scrolling, grid/list toggle, and full-screen image viewing with pinch-to-zoom.

The project follows the MVVM architecture with Combine for reactive data binding and includes unit tests with mocks to ensure maintainability and scalability.**


**✨ Features**
- Splash Screen with Lottie animation before loading photos.
- Gallery View supporting both Grid and List layouts.
- Infinite Scrolling – loads more photos when the user reaches the bottom.
- Full-Screen Mode with pinch-to-zoom in/out functionality.
- Photo Sharing – share photos via the system share sheet.
- Offline Caching – uses URLCache for efficient data loading.
- MVVM + Combine architecture for clean separation of concerns.
- Unit Tests with Mocks – testable and modular design.


## 🛠️ Tech Stack
- **SwiftUI** – UI development
- **Combine** – reactive data binding
- **Lottie** – splash animation
- **SDWebImageSwiftUI** – async image loading
- **Photos Framework** – saving images to gallery
- **URLSession + Combine** – networking
- **MVVM** – clean architecture with separation of concerns
- **XCTest** – Unit testing.
- Dependency Injection + Mocking – MockAPIClient, MockPhotoDataProvider for isolated tests.

## 📂 Project Structure
- `PhotoGalleryApp.swift` → Entry point of the app
- `SplashView.swift` / `SplashViewModel.swift` → Splash screen with animation
- `PhotoGalleryView.swift` / `PhotoGalleryViewModel.swift` → Gallery UI & state management
- `PhotoDetailView.swift` / `PhotoDetailViewModel.swift` → Full-screen photo viewer
- `PhotoDataKeeper.swift` → Handles fetching, pagination, caching
- `Photo.swift` → Photo model
- **Networking Layer**
  - `APIClient.swift` → Protocol definition
  - `URLSessionAPIClient.swift` → Concrete implementation with caching
  - `APIError.swift` → Custom error enum with descriptions
  - `ResourceParameters.swift` → Request configuration

---

**✅ Unit Testing**
- The project uses XCTest and Combine to validate business logic.
- Mocks Implemented
- MockAPIClient → simulates network responses and errors.
- MockPhotoDataProvider → simulates photo fetching and pagination.

**Key Tests**
- PhotoDetailViewModelTests
- Reset zoom functionality.
- Successful and failed image loading.
- Share item logic.
- PhotoGalleryViewModelTests
- Initial photos are loaded correctly.
- Grid/List layout toggle.
- Infinite scrolling with next page loading.

**🚀 Getting Started**
Clone the repository:
git clone https://github.com/yourusername/PhotoGalleryApp.git
Open the project in Xcode:
open PhotoGalleryApp.xcodeproj
Run the app on a simulator or physical device.

**📱 Requirements**
iOS 15.0+
Xcode 15+
Swift 5.9+

**🧪 Running Tests**
Run tests using Xcode’s Product → Test menu or:
⌘ + U
