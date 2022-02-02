import UIKit
import Flutter
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      GeneratedPluginRegistrant.register(with: self)
      FirebaseApp.configure()
      
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let channel = FlutterMethodChannel(name: "flutter.native/helper", binaryMessenger: controller.binaryMessenger)
      
      channel.setMethodCallHandler({(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        
          if(call.method == "getLanguageCode"){
          
              let textStringText = call.arguments as! String
              let languageId = NaturalLanguage.naturalLanguage().languageIdentification()

              languageId.identifyLanguage(for: textStringText) { (languageCode, error) in
                if let error = error {
                  print("Failed with error: \(error)")
                  result(error)
                  return
                }
                if let languageCode = languageCode, languageCode != "und" {
                  print("Identified Language: \(languageCode)")
                  result(languageCode)
                } else {
                  print("No language was identified")
                  result("No language was identified")
                }
              }
          }
          
      })
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
