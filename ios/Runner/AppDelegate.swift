import UIKit
import Flutter
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let channel = FlutterMethodChannel(name: "flutter.native/helper",binaryMessenger: controller.binaryMessenger)
      
      channel.setMethodCallHandler({(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        
          guard call.method == "getLanguageCode" else {
              result(FlutterMethodNotImplemented)
              return
          }
          
          let textStringText = call.arguments as String
          let languageId = NaturalLanguage.naturalLanguage().languageIdentification()

          languageId.identifyLanguage(for: textStringText) { (languageCode, error) in
            if let error = error {
              print("Failed with error: \(error)")
              result.success(error)
              return
            }
            if let languageCode = languageCode, languageCode != "und" {
              print("Identified Language: \(languageCode)")
              result.success(languageCode)
            } else {
              print("No language was identified")
              result.success("No language was identified")
            }
          }
          
      })
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
