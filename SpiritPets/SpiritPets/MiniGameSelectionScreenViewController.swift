//
//  MiniGameSelectionViewController.swift
//  SpiritPets
//
//  Created by Augusto Falcão on 11/30/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import UIKit
import SpriteKit
import WatchConnectivity

class MiniGameSelectionScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WCSessionDelegate {
    
    @IBOutlet var miniGameTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    var miniGameViewController = MiniGameViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startConnectivity()
        
        backButton.imageView?.image = UIImage.init(named: "backButton")
        miniGameTableView.dataSource = self
        miniGameTableView.delegate = self
        
        miniGameTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func onBackButtonTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return MiniGameList.nameArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MiniGameCellIdentifier") as! MiniGameTableViewCell
        
        cell.backgroundImageView.image = MiniGameList.getBackgroundImageOf(index: indexPath.section)
        cell.nameLabel.text = MiniGameList.getNameOf(index: indexPath.section)
        cell.nameLabel.clipsToBounds = true
        cell.nameLabel.layer.cornerRadius = 10
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        miniGameViewController.numberScene = indexPath.section + 1
        
        self.performSegue(withIdentifier: "MiniGameIdentifier", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat( tableView.frame.height / 100 )
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        
        self.present(miniGameViewController, animated: true, completion: { self.miniGameViewController.numberScene = 0 })
    }
    
    
    @IBAction func onSwapRight(_ sender: UISwipeGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
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
}
