# Champion Tracker - iOS App

**Champion Tracker** is an iOS app developed to help players track their performance in games like *League of Legends* or similar. This app allows users to monitor key statistics such as win rates, KDA (Kills/Deaths/Assists), and other relevant data points, providing valuable insights into gameplay trends.

## Features

* **Champion Stats Tracking**: Track vital stats such as KDA, win rates, and champion pick frequency.
* **Match History**: Store and view your detailed match history with champion picks and results.
* **Performance Trends**: Visualize your performance over time with charts and graphs.
* **Champion Search**: Search and view individual champion stats.
* **API Integration**: Automatically syncs with game APIs (e.g., Riot API for *League of Legends*) to retrieve match data.

## Technologies Used

* **Language**: Swift 5.x
* **Frameworks**:

  * UIKit for building the user interface
  * Core Data for local data persistence
  * Alamofire for network requests
  * Charts for displaying performance data visually
* **API**: Integration with the *League of Legends* API (Riot API) or other game-specific APIs for retrieving match data.
* **Database**: Core Data for storing user and match data.

## Installation

To get started with Champion Tracker on iOS, follow these steps:

1. **Clone the repository**:

   ```bash
   git clone https://github.com/username/champion-tracker-ios.git
   ```

2. **Open the project**:

   * Open the `ChampionTracker.xcworkspace` file in Xcode.

3. **Install dependencies** (if using CocoaPods or Swift Package Manager):

   * If using CocoaPods, run:

     ```bash
     pod install
     ```

4. **Set up API keys**:

   * Create an account with [Riot Games](https://developer.riotgames.com/) and get an API key.
   * Add the API key in the app’s configuration files (typically in a `.plist` or `.json` file).

5. **Run the app**:

   * Select your target device or simulator in Xcode.
   * Click `Run` to build and launch the app.

## Screenshots

Include some screenshots of the app to give users a preview of what they can expect (optional).

## Contributing

We welcome contributions to the Champion Tracker iOS app! If you'd like to contribute:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-name`).
3. Make your changes and commit them (`git commit -am 'Add new feature'`).
4. Push to the branch (`git push origin feature-name`).
5. Submit a pull request.

Please make sure your code follows the Swift style guidelines.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

--
