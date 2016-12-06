//
//  MiniGameSelectionViewController.swift
//  SpiritPets
//
//  Created by Augusto Falcão on 11/30/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import UIKit
import SpriteKit

class MiniGameSelectionScreenViewController: UITableViewController {
    
    @IBOutlet var miniGameTableView: UITableView!
    
    var miniGameViewController = MiniGameViewController()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let pet = PetChoosed(name: "Pardaemon")
        pet.xpUp(xp: 400)
        
        
        miniGameTableView = UITableView()
        
        miniGameTableView.dataSource = self
        miniGameTableView.delegate = self
        
        miniGameTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MiniGameList.nameArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MiniGameCellIdentifier") as! MiniGameTableViewCell
        
        cell.backgroundImageView.image = MiniGameList.getBackgroundImageOf(index: indexPath.row)
        cell.nameLabel.text = MiniGameList.getNameOf(index: indexPath.row)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        miniGameViewController.numberScene = indexPath.row + 1
        
        self.performSegue(withIdentifier: "MiniGameIdentifier", sender: nil)
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        
        self.present(miniGameViewController, animated: true, completion: { self.miniGameViewController.numberScene = 0 })
    }
    
}
