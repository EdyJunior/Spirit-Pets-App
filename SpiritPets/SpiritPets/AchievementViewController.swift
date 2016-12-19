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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: instant message treta
    
    func uploadingChanges(_ data: [String : Any]) {
        print("\nrecebendo iPhone\n\(data)\n")
        
        if data.keys.first == "command" {
            let cmd = data["command"] as! Int
            switch cmd {
            case 1:
                let lunch = Lunch(gain: 10, time: 10) //60
                PetManager.sharedInstance.feed(with: lunch)
            case 2:
                // sleep
                //PetManager.sharedInstance.sleep(with: )
                break
            case 3:
                let exercise = Exercise(cost: 30, gain: 30, time: 15) //3600
                PetManager.sharedInstance.exercise(typeOfExercise: exercise)
            default:
                print("O debug tá bom demais!")
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
            print("\nenviando iPhone\n")
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
