//
//  AppDelegate.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/04.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import FirebaseCore
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        self.appCoordinator = AppCoordinator(window: window!)
        appCoordinator?.start()
        
        //카카오 로그인
        KakaoSDK.initSDK(appKey: "8c9f75191418c58ae3116ceb63721938")

        //파이어베이스 초기화
        FirebaseApp.configure()
        registerRemoteNotification()
        
        return true
    }

    //카카오 로그인
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if AuthApi.isKakaoTalkLoginUrl(url) {
            return AuthController.handleOpenUrl(url: url)
        }

        return false
    }

    // MARK: UISceneSession Lifecycle
//    @available(iOS 13.0, *)
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    @available(iOS 13.0, *)
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }
}

// MARK: 푸시
extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    private func registerRemoteNotification() {
        //파베 가이드
        //remote notifications 등록
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }

        UIApplication.shared.registerForRemoteNotifications()

        Messaging.messaging().delegate = self
//        Messaging.messaging().token { token, error in
//            if let error = error {
//                print("Error fetching FCM registration token: \(error)")
//            } else if let token = token {
//                print("FCM registration token: \(token)")
//                UserDataManager.sharedInstance.pushToken = token
//                APIClient.updateDeviceToken(deviceToken: token)
//            }
//        }
    }

    //앱이 foreground상태 일 때, 알림이 온 경우 어떻게 표현할 것인지 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // 푸시가 오면 alert, badge, sound표시를 하라는 의미
        completionHandler([.alert, .badge, .sound])
    }

    // push가 온 경우 처리
    //    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    //
    //        // deep link처리 시 아래 url값 가지고 처리
    //        let url = response.notification.request.content.userInfo
    //        print("url = \(url)")
    //
    //        // if url.containts("receipt")...
    //    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }

    //토큰이 업데이트될 때마다 알림
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")

        //앱 처음 깔려서 기존 토큰 지워야할 경우
        if UserDataManager.sharedInstance.pushToken == "" {
            UserDataManager.sharedInstance.pushToken = fcmToken ?? ""
            APIClient.updateDeviceToken(deviceToken: fcmToken ?? "") { pushTokenID in
                UserDataManager.sharedInstance.pushTokenID = pushTokenID
                APIClient.deleteDeviceTokenOfTable { _ in }
            }
        } else {
            UserDataManager.sharedInstance.pushToken = fcmToken ?? ""
            APIClient.updateDeviceToken(deviceToken: fcmToken ?? "") { _ in }
        }
    }
}
