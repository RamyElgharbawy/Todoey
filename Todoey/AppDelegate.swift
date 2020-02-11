//
//  AppDelegate.swift
//  Todoey
//
//  Created by Reimo on 1/25/20.
//  Copyright © 2020 Reimo. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)

        
        do{
             _ = try Realm()
        }catch{
            print("Error Initializing new realm ,\(error)")
        }
        
        return true
    }

    
}

