//
//  Flavor_FusionApp.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 2/5/24.
//

import SwiftUI
import UserNotifications

@main
struct FlavorFusionApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State private var bleManager: BLEManager?  // Declare BLEManager as an optional

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bleManager ?? BLEManager(spiceDataViewModel: SpiceDataViewModel()))  // Provide a default if bleManager is nil
                .onAppear {
                    if bleManager == nil {
                        bleManager = BLEManager(spiceDataViewModel: SpiceDataViewModel())
                    }
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    // This method will allow the banner notification to show even if the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
