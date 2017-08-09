//
//  AppDelegate.swift
//  SpiritPets
//
//  Created by Edvaldo Junior on 28/11/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import UIKit
import Firebase

protocol SaveStatusDelegate {
    
    var lastActivate: Date { get set }
    
    var backgroundTime: TimeInterval { get set }
    
    func save()
    
    func load(after time: TimeInterval)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var multipeerManager: MultipeerManager!
    var gameArray = [0,0,0,0,0,0,0,0,0]
    var gameTurn: Bool?
    var gameUser: Int?
    
    var saveDelegate: SaveStatusDelegate? = nil
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if defaults.bool(forKey: "runBefore"){
            let mainStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
            self.window?.rootViewController = mainStoryBoard.instantiateViewController(withIdentifier: "MainScreenViewController")
        }

        multipeerManager = MultipeerManager()//apenas inclua essa linha antes do return nesse metodo.
        
        FirebaseApp.configure() //configure firebase
        
        return true
    }
    
    func receiveMessage(dic: NSDictionary) {
        self.gameArray = dic["gameArray"] as! [Int]
        self.gameTurn = false
//        print(self.gameArray)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
//        print("desativado")
        if defaults.bool(forKey: "runBefore") {
            saveDelegate?.save()
            saveDelegate?.lastActivate = Date()
        }
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
//        print("background")
    }
    
//    func applicationWillEnterForeground(_ application: UIApplication) {print("Foreground") }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
//        print("Ativo")
        if defaults.bool(forKey: "runBefore") {
            saveDelegate!.backgroundTime = Date().timeIntervalSince(saveDelegate!.lastActivate)
            saveDelegate!.load(after: saveDelegate!.backgroundTime)
//            print("ACTIV Passaram-se \(saveDelegate!.backgroundTime) seg")
        } else {
//            print("Não escolheu ainda 2")
        }
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        //        if defaults.bool(forKey: "runBefore") {
        //            saveDelegate?.save()
        //            saveDelegate?.lastActivate = Date()
        //        }
//        print("Terminate")
    }

}
