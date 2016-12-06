//
//  PetSelectionViewController.swift
//  SpiritPets
//
//  Created by padrao on 29/11/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import UIKit

class PetSelectionViewController: UIViewController {
    
    let pickerView = AKPickerView(frame: CGRect(origin: CGPoint.init(x: 0, y: 20), size: CGSize(width:200, height: 200)))
    @IBOutlet var statusLabels: [UILabel]!
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var atkLabel: UILabel!
    @IBOutlet weak var dfsLabel: UILabel!
    
    var chibis: [[String : Any]] = []

    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.pickerView.frame.size.width = view.frame.width
        self.pickerView.frame.size.height = view.frame.height / 3
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.interitemSpacing = CGFloat(20)
        self.view.addSubview(pickerView)
        
        guard let path = Bundle(for: type(of: self)).path(forResource: "PetsAttributes", ofType: "json")
            else { fatalError("Can't find PetsAttributes JSON resource.") }
        
        getPets(fromJsonWithPath: path)
        setUpLabels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let selectedIndex = 1
        self.pickerView.selectItem(selectedIndex)
        self.pickerView.reloadData()
        
        let pet: [String : Any] = chibis[selectedIndex]
        let att = pet["baseBattleAtt"] as! [String : Int]
        
        self.updateStatusLabels(status: [att["hp"]!,
                                         att["atk"]!,
                                         att["dfs"]!])
    }
    
    func getPets(fromJsonWithPath path: String) {
        
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let json = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [[String : Any]]
        
        chibis = json.filter { (pet) -> Bool in
            if pet["stage"] as! String == PetStage.chibi.rawValue {
                return true
            }
            return false
        }
    }
    
    @IBAction func letsgoTap(_ sender: UIButton) {
        
        let story = UIStoryboard.init(name: "BergStoryboard", bundle: nil)
        
        let mainView = story.instantiateViewController(withIdentifier: "MainScreenViewController") as! MainScreenViewController
        
        let pet = chibis[pickerView.selectedItem]
        mainView.petName = pet["name"] as! String!
        show(mainView, sender: self)
        
        
    }
    
    
    //call this to round the status labels.
    func setUpLabels(){
        
        for label in statusLabels{
            label.layer.masksToBounds = true
            label.layer.cornerRadius = 10
        }
    }
    
    //status must be a array with 3 values: hp, atk, dfs.
    func updateStatusLabels(status:[Int]){
        
        for i in 0...statusLabels.count - 1{
            statusLabels[i].frame.size.width = 20 * CGFloat(status[i])
        }
    }
}

extension PetSelectionViewController: AKPickerViewDelegate{
    
    func pickerView(_ pickerView: AKPickerView, imageForItem item: Int) -> UIImage {
        return UIImage(named: chibis[item]["frontImage"] as! String)!
    }
    
    func pickerView(_ pickerView: AKPickerView, didSelectItem item: Int) {
        
        let pet: [String : Any] = chibis[item]
        let att = pet["baseBattleAtt"] as! [String : Int]
        
        self.updateStatusLabels(status: [att["hp"]!,
                                         att["atk"]!,
                                         att["dfs"]!])
    }
}

extension PetSelectionViewController: AKPickerViewDataSource{
    
    func numberOfItemsInPickerView(_ pickerView: AKPickerView) -> Int {
        return chibis.count
    }
}
