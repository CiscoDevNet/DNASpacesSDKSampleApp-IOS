//
//  AppDelegate.swift
//  OpenRoaming
//
//  Created by rajesh36 on 25/11/19.
//  Copyright © 2019 rajesh36. All rights reserved.
//

import UIKit
import NetworkExtension
import UserNotifications
import Firebase
import OpenRoaming

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let gcmMessageIDKey = "gcm.message_id"
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        self.handleMessageToken()
        self.registerForRemoteNotifications(application)
        
        print("Notifications: \(NotificationHelper.list().count)")
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let navigationController = mainStoryboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        self.window?.rootViewController = navigationController
        
        OpenRoaming.registerSdk(appId: appId, dnaSpacesKey: dnaSpacesKey,region:Region.US ,registerSdkHandler: {
            signingState, error in
            DispatchQueue.main.async {

                if (signingState == SigningState.signed){
                    let tabbarViewController: UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! UITabBarController
                    navigationController.pushViewController(tabbarViewController, animated: false)
                }
            }
        })
        self.window?.makeKeyAndVisible()

        return true
    }
    
    func registerForRemoteNotifications(_ application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })

        application.registerForRemoteNotifications()
    }
    
    func handleMessageToken() {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                NotificationHelper.pushIdentify = result.token
                
                if NotificationHelper.isEnabled == .undefined {
                    NotificationHelper.isEnabled = .enabled
                }
            }
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
      if let notification = Notification.fromUserInfo(userInfo) {
            self.handleNotification(notification: notification)
        }
      completionHandler(UIBackgroundFetchResult.newData)
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
      withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        if let notification = Notification.fromUserInfo(userInfo) {
            self.handleNotification(notification: notification)
        }
        completionHandler([[.alert, .sound]])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        if let notification = Notification.fromUserInfo(userInfo) {
            self.handleNotification(notification: notification)
        }
        completionHandler()
    }
    
    private func handleNotification(notification: Notification) {
        OpenRoaming.handleNotification(message: notification.body, notificationHandler: { disregardNotification, message, error in
            if error != nil {
                print(error as Any)
            } else {
                guard let disregardNotification = disregardNotification else {
                    return
                }
                
                if !disregardNotification {
                    NotificationHelper.add(notification)
                }
            }
        })
    }
}

extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
    if(fcmToken != nil){
    let dataDict:[String: String] = ["token": fcmToken!]
    NotificationCenter.default.post(name: UserNotifications.Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
  }
}
