//
//  AppDelegate.swift
//  Yetda2_iOS
//
//  Created by 임수현 on 2021/12/02.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // firebase update 확인
        FirestoreManager.shared.getRecentUpdatedDate { firestoreUpatedAt in
            if firestoreUpatedAt != RealmManager.shared.updatedAt{
                print("Firestore updated! Realm also need update.")
                
                // realm에 update 저장
                try RealmManager.shared.resetUpdatedAt(firestoreUpatedAt)
                
                // realm에 gifts 저장
                FirestoreManager.shared.getGifts { firestoreGifts in
                    let gifts: [RealmGift] = firestoreGifts.map { RealmGift(firestoreGift: $0) }
                    try RealmManager.shared.resetGifts(gifts)
                }
                
                // realm에 questions 저장
                FirestoreManager.shared.getQuestions { firestoreQuestions in
                    let questions: [RealmQuestion] = firestoreQuestions.map { RealmQuestion(firestoreQuestion: $0) }
                    try RealmManager.shared.resetQuestions(questions)
                }
            }
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

