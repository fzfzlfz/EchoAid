# EchoAid
---

## Getting Started with EchoAid
- **Brief Description**: This guide will walk you through the steps to get EchoAid up and running on your development environment. EchoAid is an iOS application built using Swift, designed to improve the autonomy and daily life of individuals with visual impairments and cognitive challenges through innovative assistive technology.

- **What Technology does it use?** It utilizes Near Field Communication (NFC) technology to enable users to identify objects and manage tasks through voice-activated tags, enhancing their ability to navigate their surroundings independently.

- **Why Use It?** EchoAid is not just a product; it's a lifeline for individuals facing daily challenges due to visual impairments, cognitive difficulties, or age-related issues. By harnessing the power of Near Field Communication (NFC) technology, EchoAid transforms ordinary objects into beacons of independence. It empowers users to navigate their environment with confidence, turning every interaction into an opportunity for self-reliance and dignity.

## Table of Contents
- A navigable table of contents to quickly access various sections of the README.

## Prerequisites

Before you begin, ensure you have the following installed:
- Xcode 12 or later, available from the [Mac App Store](https://apps.apple.com/app/xcode/id497799835).
- An iOS device or simulator running iOS 14.0 or later.
- Apple Developer account (optional for personal testing, required for app distribution).

## Installation

1. **Clone the EchoAid Repository**:
   Open Terminal and run the following command to clone the EchoAid repository:
   ```
   git clone https://github.com/fzfzlfz/EchoAid.git
   ```

2. **Open the Project in Xcode**:
   Navigate to the cloned repository directory, and open the `EchoAid.xcodeproj` or `project.xcworkspace` file in Xcode. If you are using CocoaPods or any external libraries, it's recommended to open `project.xcworkspace`.

3. **Configure Project Settings**:
   - Select the `EchoAid` target in Xcode's Project Navigator.
   - Go to the General tab and configure your Bundle Identifier, Team, and Deployment Info.

4. **Install Dependencies** (if your project uses external libraries, mention steps here, such as CocoaPods installation or Swift Package Manager).

5. **Run the Application**:
   - Connect your iOS device via USB or select a simulator.
   - Select your device from the list of available devices in the toolbar.
   - Press the Run button (▶) or use the `Cmd + R` shortcut to build and run the application on your device or simulator.

## Exploring the Project

- **EchoAid App Components**: Familiarize yourself with the main components of the EchoAid app, including:
   - `ContentView.swift`: The entry point for the app's user interface.
   - `NFCManager.swift`: Handles Near Field Communication (NFC) operations.
   - `AVAudioRecorder.swift`: Manages audio recording and playback.
   - `Persistence.swift`: Implements data persistence for your app.

- **Assets**: Explore the `Assets.xcassets` directory to see how the app's visual assets, such as app icons and accent colors, are organized.


## How It Works

Here are EchoAid's main features:

**Step 1: Attach NFC Tags**

These aren't just tags; they're keys to unlocking a world where every object has a voice. Users attach these keys to items that are essential in their daily routines or challenging to distinguish.

**Step 2: Open the Project in Xcode**

Record Voice Messages with the EchoAid App: This is where personalization meets technology. Users can record messages in their own voice or a loved one's, making each interaction not just informative but also familiar and comforting.

4. **Configure Project Settings**:
   - Select the `EchoAid` target in Xcode's Project Navigator.
   - Go to the General tab and configure your Bundle Identifier, Team, and Deployment Info.


### User scenarios to apply EchoAid in daily life:

**Scenario 1: Blind User - Marking Medications and Food Items**

Cecilia's independence shines even brighter with EchoAid. Last week, she received two new prescriptions from her doctor, identical to the touch but distinct in purpose. Despite her family being at work, Cecilia navigates this challenge with ease. A gentle tap of her phone against the tags, and she hears, "Antibiotic, take with lunch," clearly distinguishing it from the other. Later, as she prepares her meal, EchoAid guides her again, confirming, "Salad mix, expires on Friday," ensuring her lunch is fresh and healthy. EchoAid not only grants Cecilia the freedom to manage her health independently but also supports her in making informed choices about her diet, all by herself.

**Scenario 2: Elderly User with Memory and Vision Impairment**

Mrs. Liu is 68 years old with bad memory and impaired vision. She starts her day with a reminder from her EchoAid app, saying, "Good morning, Mrs. Liu! Time to take your heart medication." She walks to the medicine cabinet, where she finds her medications neatly organized with EchoAid stickers. She picks up the first bottle, and her EchoAid reader, integrated into her smartphone, plays back the message, "Blood pressure pill, take one with breakfast." Relieved, she takes her medication without confusion.

## Contributing
We welcome contributions to EchoAid! Please read our contribution guidelines for more information on how you can contribute to the project.

## FAQ/ Troubleshooting
- A section addressing common questions or issues users might encounter and their solutions.

## Acknowledgments
- **Acknowledgments**: Thank you to Rewriting the Code for oragnising Black Wings Hack, and giving us this opportunity to collaborate on this project!

