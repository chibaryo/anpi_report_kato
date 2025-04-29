import Flutter
import UIKit
import Firebase
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    FirebaseApp.configure() //この行を追加 2025.03.10
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // MARK: - Background Notification Handling
override func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable: Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
) {
    // Handle background notification here
    print("Background notification received: \(userInfo)")
    
    // Update badge count if needed
    let currentBadge = UIApplication.shared.applicationIconBadgeNumber
    UIApplication.shared.applicationIconBadgeNumber = currentBadge + 1
    
    // Extract notification data and pass it to Flutter
    if let notificationId = userInfo["notificationId"] as? String {
        // Store the notification ID to be used when app becomes active
        UserDefaults.standard.set(notificationId, forKey: "pendingNotificationId")
    }
    
    // Always call completion handler
    completionHandler(.newData)
  }

/*  override func applicationDidBecomeActive(_ application: UIApplication) {
    // Check if there's a pending notification to handle
    if let notificationId = UserDefaults.standard.string(forKey: "pendingNotificationId") {
        // Clear the stored value
        UserDefaults.standard.removeObject(forKey: "pendingNotificationId")
        
        // Send the notification ID to Flutter
/*        if let controller = window?.rootViewController as? FlutterViewController {
            let channel = FlutterMethodChannel(name: "com.rabbitway.anpireport.staging.app/notification", binaryMessenger: controller.binaryMessenger)
            channel.invokeMethod("onNotificationOpened", arguments: notificationId)
        } */
    }
  } */
}
