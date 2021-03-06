//
//  AchievementViewController.swift
//  SpiritPets
//
//  Created by padrao on 08/12/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import UIKit
import WatchConnectivity

class AchievementViewController: UIViewController, WCSessionDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        startConnectivity()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onGoBackTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: instant message treta
    
    func uploadingChanges(_ data: [String : Any]) {
//        print("\nrecebendo iPhone\n\(data)\n")
        
        if data.keys.first == "command" {
            let cmd = data["command"] as! Int
            switch cmd {
            case 1:
                let lunch = Lunch(gain: 10, time: 10) //60
                PetManager.sharedInstance.feed(with: lunch)
            case 2:
                PetManager.sharedInstance.sleep(during: sleepDefaultTime)
            case 3:
                let exercise = Exercise(cost: 30, gain: 30, time: 15) //3600
                PetManager.sharedInstance.exercise(typeOfExercise: exercise)
            default: break
//                print("O debug tá bom demais!")
            }
        }
    }
    
    let session = WCSession.default()
    
    func startConnectivity() {
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }
    
    func send(message: [String : Any]) {
        if session.isReachable {
//            print("\nenviando iPhone\n")
            session.sendMessage(message, replyHandler: nil, errorHandler: nil)
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            self.uploadingChanges(message)
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        //
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        //
    }

}
