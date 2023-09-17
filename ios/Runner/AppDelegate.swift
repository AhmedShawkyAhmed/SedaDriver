import UIKit
import Flutter
import FirebaseCore
import GoogleMaps
import Foundation
import os

let preferenceTokenKey : String = "apiToken"

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate  {
    
    var bgTaskId: UIBackgroundTaskIdentifier? = nil

    func log(message : String) {
        if #available(iOS 14.0, *) {
            let logger = Logger()
            logger.log("\(message)")
        } else {
            NSLog(message)
        }
    }
    
    func toggleOnline(){
        guard let url = URL(string: "https://bt-dev-ride.magdsofteg.xyz/api/toggleOnline?is_online=0") else {
            return
        }
        
        self.log(message: "AppDelegate: url parsed")
        
        var request = URLRequest(url: url)

        let prefs = UserDefaults.standard
        guard let token = prefs.string(forKey: preferenceTokenKey) else {
            return
        }
        self.log(message: "AppDelegate: token = \(token)")
        
        // method, body, header
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("520", forHTTPHeaderField: "appKey")
        request.setValue("en", forHTTPHeaderField: "Accept-Language")
        
        self.log(message: "AppDelegate: request start")
        
        let task = URLSession.shared.dataTask(with: request) { data, res, error in
            self.log(message: "AppDelegate: request done")
            
            guard let data  = data, error == nil else{
                return
            }
            
            do{
                let response  = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                self.log(message: "AppDelegate: SUCCESS: \(response)")
            }
            catch {
                self.log(message: "AppDelegate: Response Error: \(error)")
            }
            
            // End the background task once the request is complete
            if let validBgTaskId = self.bgTaskId {
                self.log(message: "AppDelegate: end background")
                UIApplication.shared.endBackgroundTask(validBgTaskId)
                self.bgTaskId = UIBackgroundTaskIdentifier.invalid
            }
        }
        task.resume()
    }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    self.log(message: "AppDelegate: didFinishLaunchingWithOptions!")
    GMSServices.provideAPIKey("AIzaSyD03tmmafIJahLSvVG3xHQQa_7NDrEZ1i8")
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10.0, *) {
         UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      
    FlutterMethodChannel(
        name: "UserChannel",
        binaryMessenger: controller.binaryMessenger
    ).setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        let prefs = UserDefaults.standard
        switch call.method {
            case "addToken":
                self.log(message: "CallNativeFromFlutter: NativeToken: \(call.arguments)")
                prefs.set(call.arguments as? String, forKey: preferenceTokenKey)
                self.log(message: "CallNativeFromFlutter: Api Token Saved Successfully")
                result(nil)
            case "removeToken":
                prefs.removeObject(forKey: preferenceTokenKey)
                self.log(message: "CallNativeFromFlutter: Api Token removed Successfully")
                result(nil)
            default:
            result(FlutterMethodNotImplemented)
        }
    })
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
  override func applicationWillTerminate(_ application: UIApplication) {
      bgTaskId = UIApplication.shared.beginBackgroundTask {
          // End the task if time expires.
          UIApplication.shared.endBackgroundTask(self.bgTaskId!)
          self.bgTaskId = UIBackgroundTaskIdentifier.invalid
      }
      
      self.toggleOnline()
      self.log(message: "AppDelegate: applicationWillTerminate!")
  }

  override func applicationDidEnterBackground(_ application: UIApplication) {
      self.log(message: "AppDelegate: applicationDidEnterBackground!")
  }
}
