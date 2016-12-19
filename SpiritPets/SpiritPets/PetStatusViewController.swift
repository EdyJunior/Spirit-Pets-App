//
//  PetStatusViewController.swift
//  SpiritPets
//
//  Created by padrao on 06/12/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import UIKit
import WatchConnectivity

class PetStatusViewController: UIViewController , WCSessionDelegate {
    
    @IBOutlet weak var viewImage: UIImageView!
    @IBOutlet weak var mySubViewImage: UIImageView!
    @IBOutlet weak var mySubView: UIView!
    @IBOutlet weak var backButton: UIButton!

    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var atkLabel: UILabel!
    @IBOutlet weak var defLabel: UILabel!
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var evolutionLabel: UILabel!
    @IBOutlet weak var experenceLabel: UILabel!
    @IBOutlet weak var staminiaLabel: UILabel!
    @IBOutlet weak var sleepLabel: UILabel!
    @IBOutlet weak var feedLabel: UILabel!
    var pet: PetChoosed!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startConnectivity()
        setupLabels()
    
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setupLabels),name: NSNotification.Name(rawValue: "UpdateStatusNotification"), object: nil)

        self.viewImage.image = UIImage.init(named: "background")
        self.mySubViewImage.image = UIImage.init(named: "roundedRect")
        self.mySubView.clipsToBounds = true
        self.mySubViewImage.clipsToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }

    override func viewWillDisappear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onGoBackTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupLabels(){
        send(message: ["fed" : 22])
        let battleAtt = pet.battleAtt
        let growthAtt = pet.growthAtt
        
        hpLabel.text = "HP: \(battleAtt.hp!)"
        atkLabel.text = "ATK: \(battleAtt.atk!)"
        defLabel.text = "DEF: \(battleAtt.dfs!)"
        levelLabel.text = "Level: \(battleAtt.lv!)"
        evolutionLabel.text = "Evolution Stage: \(pet.stage)"
        experenceLabel.text = "\(battleAtt.xp!)"
        staminiaLabel.text = "\(growthAtt.stamina!)"
        sleepLabel.text = "\(growthAtt.awake!)"
        feedLabel.text = "\(growthAtt.fed!)"
    }
    
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
