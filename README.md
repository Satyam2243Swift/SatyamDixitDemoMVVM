# SatyamDixitDemoMVVM

**Swift 5 - Programming language
UIKit - For building the user interface
Auto Layout - For responsive design
MVVM Architecture - Clean code structure
URLSession - For API calls**

Why I chose these technologies
MVVM Architecture

ViewModel handles all business logic and calculations
View only handles UI updates
Model contains data structures
Easy to test and maintain

UIKit with Programmatic UI

Built everything in code (no Storyboards)
Better control over layouts
No merge conflicts
Easier to review code

**Protocol-based Service**
swiftprotocol HoldingsServiceProtocol {
    func fetchHoldings(completion: @escaping (Result<[Holding]?, Error>) -> Void)
}

Easy to mock for testing
Can swap implementations easily


**UI Features**

Clean, simple design
Green/red colors for profit/loss
Smooth expand/collapse animation
Works on all iPhone sizes


**System Requirements**

iOS 15.0+ 
Xcode 16 (because my Mac has macOS 15.5)
Swift 5

Current Status
✅ Working Features:

API integration working
All calculations correct
Smooth animations
Responsive design
Clean architecture

**What I want to improve next
Short Term**

**Add unit tests for ViewModel and calculations
Add pull-to-refresh functionality
Better error handling with user-friendly messages
Loading indicators**


**Code Quality**
No constraint warnings - Clean Auto Layout
Memory efficient - Proper weak references used
Reusable components - Custom views can be reused
Clean code - Well-organized and commented

**Installation**
Download the project
Open in Xcode 16
Build and run on iOS 15+ device/simulator
