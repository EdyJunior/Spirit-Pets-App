//
//  MPFindOpponentViewController.swift
//  SpiritPets
//
//  Created by padrao on 13/12/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MPFindOpponentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate ,MultipeerDelegate {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var gameTurn: Bool?
    var gameUser: Int?
    var context: Data!//this content the oppponent image name
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        appDelegate.multipeerManager.browser.invitePeer(selectedPeer, to: appDelegate.multipeerManager.session, withContext: NSKeyedArchiver.archivedData(withRootObject:  PetManager.sharedInstance.petChoosed.frontImageName), timeout: 20)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /// MULTIPEER DELEGATE
    
    func foundPeer() {
        tableView.reloadData()
    }
    
    func lostPeer() {
        tableView.reloadData()
    }
    
    func invitationWasReceived(fromPeer: MCPeerID, withData: Data) {
        let alert = UIAlertController(title: "Challenge Request", message: "\(fromPeer.displayName) wants to challenge you!", preferredStyle: UIAlertControllerStyle.alert)
        
        let accept = UIAlertAction(title: "Accept", style: UIAlertActionStyle.default) { (alertAction) -> Void in
            self.gameTurn = true
            self.gameUser = 1
            //self.context = withData
            self.appDelegate.multipeerManager.invitationHandler(true, self.appDelegate.multipeerManager.session)
            //let dictionary: [String: AnyObject] = ["turn": self.gameTurn as AnyObject, "user": self.gameUser as AnyObject ]
            //self.performSegue(withIdentifier: "battleSegue", sender: dictionary)
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
    
    func connectedWithPeer(peerID: MCPeerID, imageName: String) {
        /*let data = NSKeyedArchiver.archivedData(withRootObject: PetManager.sharedInstance.petChoosed.frontImageName)
        do{
            try self.appDelegate.multipeerManager.session.send(data, toPeers: [peerID], with: .reliable)

        }catch{
            print("Error ao enviar...")
        }*/
        print(peerID)
        OperationQueue.main.addOperation {
            let dictionary: [String: AnyObject] = ["turn": self.gameTurn as AnyObject, "user": self.gameUser as AnyObject, "imageNameOpponent": imageName as AnyObject ]
            self.performSegue(withIdentifier: "battleSegue", sender: dictionary)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let battleVC = segue.destination as! BattleViewController
        //battleVC.dictionary = ["turn": self.gameTurn as AnyObject, "user": self.gameUser as AnyObject]
        battleVC.dictionary = sender as! [String: AnyObject]
        print("battleVC \(battleVC.dictionary)")
        //battleVC.opponentImageName = NSKeyedUnarchiver.unarchiveObject(with: context) as! String
        //Could not cast value of type '__NSDictionaryI' (0x1a07a2788) to 'NSString' (0x1a07ad7e8)
    }
    
    /*func receiveDataWithNotification(notification: Notification){
        self.context = notification.userInfo?["data"] as! Data
        let dictionary: [String: AnyObject] = ["turn": self.gameTurn as AnyObject, "user": self.gameUser as AnyObject ]
        self.performSegue(withIdentifier: "battleSegue", sender: dictionary)
        
    }*/

}
