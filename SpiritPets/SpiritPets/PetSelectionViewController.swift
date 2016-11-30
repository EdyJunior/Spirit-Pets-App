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
    
    let images = [UIImage.init(named: "pet0"), UIImage.init(named: "pet1"),UIImage.init(named: "pet0"), UIImage.init(named: "pet1")]
    
    
    let pett0 = PetStatus(hp: 100, atk: 80, dfs: 60)
    let pett1 = PetStatus(hp: 100, atk: 70, dfs: 70)
    let pets = [ PetStatus(hp: 200, atk: 180, dfs: 60), PetStatus(hp: 150, atk: 70, dfs: 170),PetStatus(hp: 200, atk: 180, dfs: 60), PetStatus(hp: 150, atk: 70, dfs: 170)]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.pickerView.frame.size.width = view.frame.width
        self.pickerView.frame.size.height = view.frame.height / 3
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.interitemSpacing = CGFloat(20)
        self.view.addSubview(pickerView)
        
        self.setUpLabels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let selectedIndex = 1
        self.pickerView.selectItem(selectedIndex)
        self.pickerView.reloadData()
        self.updateStatusLabels(status: [pets[selectedIndex].hp, pets[selectedIndex].atk, pets[selectedIndex].dfs])
        
    }
    
    @IBAction func letsgoTap(_ sender: UIButton) {
        //TODO: perform segue
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
            statusLabels[i].frame.size.width = CGFloat(status[i])
        }
    }
    
    //pog pra testar
    struct PetStatus {
        var hp:Int
        var atk:Int
        var dfs:Int
    }
    //***************
}



extension PetSelectionViewController: AKPickerViewDelegate{
    
    func pickerView(_ pickerView: AKPickerView, imageForItem item: Int) -> UIImage {
        return images[item]!
    }
    
    func pickerView(_ pickerView: AKPickerView, didSelectItem item: Int) {
        print("selecionou \(images[item])")
        self.updateStatusLabels(status: [pets[item].hp, pets[item].atk, pets[item].dfs])
    }
}

extension PetSelectionViewController: AKPickerViewDataSource{
    func numberOfItemsInPickerView(_ pickerView: AKPickerView) -> Int {
        return images.count
    }
}




