//
//  AppDelegate.swift
//  champion-tracker Amiga Music Player
//
//  Copyright © 2018 Aleksi Sitomaniemi. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import UserNotifications
import SwiftUI
import BackgroundTasks

// Global Variables
let modulePlayer = ModulePlayer()
let moduleStorage = ModuleStorage()
let log = AMPLogger()
let settings = SettingsInteractor()
let shareUtil = ShareUtility()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  private var sharedMod: MMD?
  private lazy var dlController: DownloadController = DownloadController()
  private var bgQueue = OperationQueue()

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Customize app settings after launch
    Appearance.setup()
    configureAVSession()
    initializeBackgroundTask()
    clearOldFiles()

    // TEST LOCAL NOTIFICATIONS (Uncomment below lines to test)
    //    settings.prevCollectionSize = 0
    //    settings.newestPlayed = 152890

    // Start refreshing data
    bgQueue.maxConcurrentOperationCount = 1
    bgQueue.addOperation(RefershLatestOperation())
    UIApplication.shared.beginReceivingRemoteControlEvents()

#if DEBUG
    ReviewActions.reset()
#endif
    return true
  }

  func initializeBackgroundTask() {
    let taskRegistered = BGTaskScheduler.shared.register(forTaskWithIdentifier: "fourchamp.latest.refresh", using: nil) { task in
      log.debug("Background task initiated")
      self.executeBackgroundTask(task: task)
    }
    if taskRegistered {
      log.debug("Background task successfully scheduled")
      scheduleAppDataRefresh()
    }
  }

  func configureAVSession() {
    let audioSession = AVAudioSession.sharedInstance()
    do {
      try audioSession.setCategory(.playback, mode: .default, options: [])
      try audioSession.setActive(true)
    } catch {
      log.error("Audio session configuration failed: \(error)")
    }
  }

  func applicationWillResignActive(_ application: UIApplication) {
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
  }

  func applicationWillTerminate(_ application: UIApplication) {
    modulePlayer.cleanup()
  }

  func application(_ application: UIApplication,
                   continue userActivity: NSUserActivity,
                   restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

    guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
          let url = userActivity.webpageURL,
          let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
      return false
    }

    if components.path == "/mod", let idString = components.queryItems?.first?.value, let modId = Int(idString) {
      guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first else {
        return false
      }
      dlController.rootViewController = window.rootViewController
      dlController.show(modId: modId)
    }
    return true
  }

  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    DispatchQueue.main.async {
      if url.scheme == "fourchamp" && url.host == "modules" {
        if let idString = url.path.split(separator: "/").first, let modId = Int(idString) {
          self.dlController.show(modId: modId)
        }
      } else {
        self.dlController.showImport(for: [url])
      }
    }
    return true
  }

  func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
    return true
  }

  func scheduleAppDataRefresh() {
    let taskRequest = BGAppRefreshTaskRequest(identifier: "fourchamp.latest.refresh")
    taskRequest.earliestBeginDate = Date(timeIntervalSinceNow: 5 * 60) // Schedule to refresh after 5 minutes
    do {
      try BGTaskScheduler.shared.submit(taskRequest)
    } catch {
      print("Error scheduling app data refresh task: \(error)")
    }
  }

  func executeBackgroundTask(task: BGTask) {
    log.debug("Executing background task")
    scheduleAppDataRefresh()

    let operation = RefershLatestOperation()
    bgQueue.addOperation(operation)

    task.expirationHandler = {
      operation.cancel()
    }

    operation.completionBlock = {
      task.setTaskCompleted(success: !operation.isCancelled)
    }
  }

  func clearOldFiles() {
    let fileManager = FileManager.default
    let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    do {
      let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
      if let firstFile = fileURLs.first {
        log.debug("First file found: \(firstFile)")
      }
      // Implement file processing here
    } catch {
      log.error("Error processing files at \(documentsURL.path): \(error.localizedDescription)")
    }
  }
}
