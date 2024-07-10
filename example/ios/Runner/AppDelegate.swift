import Flutter
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    NSLog("\nHere's env -> \(Bundle.main.infoDictionary)")
    var app_name: String = Bundle.main.infoDictionary?["APP_NAME"] as? String ?? ""
    NSLog("\nHere's your app name -> \(app_name)")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
