//
//  RegisterNotification.swift
//  BarberShop
//
//  Created by Daniel Radshun on 15/08/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import UIKit
import UserNotifications

class RegisterNotification{
    
    static let shared = RegisterNotification()
    
    private init() {}
    
    func registerForPushNotifications(viewController:UIViewController, completion: @escaping (_ isGranted:Bool) -> Void) {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                granted, error in
                print("Permission granted: \(granted)")
                if granted{
                    //the registeration must be on the main task
                    DispatchQueue.main.async {
                        //regestier to the notification center
                        UIApplication.shared.registerForRemoteNotifications()
                        
                        completion(true)
                    }
                }
                else{
                    let alert = AlertService().alert(title: "קבלת התראה", body: "אם ברצונך לקבל תזכורת אנא אשר קבלת התראות מהאפליקצייה", btnAmount: 2, positive: "הגדרות", negative: "אני אוותר", positiveCompletion: {
                        self.getNotificationSettings(completion: {
                            completion(false)
                        })
                    }, negativeCompletion: {
                        completion(false)
                    })
                    
                    viewController.present(alert, animated: true)
                }
                
        }
    }
    
    private func getNotificationSettings(completion: @escaping () -> Void) {
        //open notification settings
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
}
