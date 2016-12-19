//
//  MPFindOpponentViewController.swift
//  SpiritPets
//
//  Created by padrao on 13/12/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import WatchConnectivity

class MPFindOpponentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate ,MultipeerDelegate, WCSessionDelegate {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var gameTurn: Bool?
    var gameUser: Int?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startConnectivity()
        
        // Search for peers devices and enable them to be shown
        appDelegate.multipeerManager.delegate = self
        appDelegate.multipeerManager.browser.startBrowsingForPeers()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        gameTurn = false
        gameUser = 2
        appDelegate.multipeerManager.advertiser.startAdvertisingPeer()
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func onCancelTap(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /// TABLE VIEW DELEGATE
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.multipeerManager.foundPeer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peerCell", for: indexPath)
        
        cell.textLabel?.text = appDelegate.multipeerManager.foundPeer[indexPath.row].displayName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPeer = appDelegate.multipeerManager.foundPeer[indexPath.row]
        
        appDelegate.multipeerManager.browser.invitePeer(selectedPeer, to: appDelegate.multipeerManager.session, withContext: nil, timeout: 20)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /// MULTIPEER DELEGATE
    
    func foundPeer() {
        tableView.reloadData()
    }
    
    func lostPeer() {
        tableView.reloadData()
    }
    
    func invitationWasReceived(fromPeer: String) {
        let alert = UIAlertController(title: "Challenge Request", message: "\(fromPeer) wants to challenge you!", preferredStyle: UIAlertControllerStyle.alert)
        
        let accept = UIAlertAction(title: "Accept", style: UIAlertActionStyle.default) { (alertAction) -> Void in
            self.gameTurn = true
            self.gameUser = 1
            self.appDelegate.multipeerManager.invitationHandler(true, self.appDelegate.multipeerManager.session)
        }
        
        let decline = UIAlertAction(title: "Decline", style: UIAlertActionStyle.destructive) { (alertAction) -> Void in
            self.appDelegate.multipeerManager.invitationHandler(false, nil)
        }
        
        alert.addAction(accept)
        alert.addAction(decline)
        
        OperationQueue.main.addOperation {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func connectedWithPeer(peerID: MCPeerID) {
        OperationQueue.main.addOperation {
            let dictionary: [String: AnyObject] = ["turn": self.gameTurn as AnyObject, "user": self.gameUser as AnyObject ]
            self.performSegue(withIdentifier: "battleSegue", sender: dictionary)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let battleVC = segue.destination as! BattleViewController
        battleVC.dictionary = ["turn": self.gameTurn as AnyObject, "user": self.gameUser as AnyObject]
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
                PetManager.sharedInstance.sleep(during: sleepDefaultTime)
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
