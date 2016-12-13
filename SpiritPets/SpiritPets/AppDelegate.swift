//
//  AppDelegate.swift
//  SpiritPets
//
//  Created by Edvaldo Junior on 28/11/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import UIKit

protocol SaveStatusDelegate {
    
    var lastActivate: Date { get set }
    
    var backgroundTime: TimeInterval { get set }
    
    func save()
    
    func load(after time: TimeInterval)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var saveDelegate: SaveStatusDelegate? = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        if UserDefaults.standard.bool(forKey: "runBefore"){
            let mainStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
            self.window?.rootViewController = mainStoryBoard.instantiateViewController(withIdentifier: "MainScreenViewController")
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        saveDelegate?.save()
        saveDelegate?.lastActivate = Date()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
        saveDelegate!.backgroundTime = Date().timeIntervalSince(saveDelegate!.lastActivate)
        saveDelegate!.load(after: saveDelegate!.backgroundTime)
        print("FORE Passaram-se \(saveDelegate!.backgroundTime) seg")
    }

    func applicationDidBecomeActive(_ application: UIApplication) { }

    func applicationWillTerminate(_ application: UIApplication) {
        
        saveDelegate?.save()
        saveDelegate?.lastActivate = Date()
    }
}
