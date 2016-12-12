//
//  MiniGameSelectionViewController.swift
//  SpiritPets
//
//  Created by Augusto Falcão on 11/30/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import UIKit
import SpriteKit

class MiniGameSelectionScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var miniGameTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    var miniGameViewController = MiniGameViewController()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
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
    
}
