import UIKit
import Flutter
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

UNUserNotificationCenter.current().delegate = self
UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
    // Handle the result of the authorization request
}
func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.alert, .badge, .sound])
}


   /*  GMSServices.provideAPIKey("AIzaSyDpgMDa84rGS4Q_AlUJSFtGdoRPAe9Q-KI") */
     GMSServices.provideAPIKey("AIzaSyCHTR33PFOEyhToyVDIOUI5tC166G4K3w4")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
