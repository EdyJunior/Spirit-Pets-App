//
//  PetSelectionViewController.swift
//  SpiritPets
//
//  Created by padrao on 29/11/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import UIKit

class PetSelectionViewController: UIViewController {

    
    let pickerView = AKPickerView(frame: CGRect(origin: CGPoint.init(x: 50, y: 50), size: CGSize(width:200, height: 200)))
    
    @IBOutlet var statusLabels: [UILabel]!
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var atkLabel: UILabel!
    @IBOutlet weak var dfsLabel: UILabel!
    
    let images = [UIImage.init(named: "pet0"), UIImage.init(named: "pet1")]
    //let images = ["ola", "povo"]
    
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        
        self.view.addSubview(pickerView)
        self.pickerView.reloadData()
        
        self.setUpLabels()
    }
    
    func setUpLabels(){
        for label in statusLabels{
            label.layer.masksToBounds = true
            label.layer.cornerRadius = 10
        }
        hpLabel.frame.size.width = hpLabel.frame.width/2
    }
}



extension PetSelectionViewController: AKPickerViewDelegate{
    
    func pickerView(_ pickerView: AKPickerView, imageForItem item: Int) -> UIImage {
        return images[item]!
    }
    
    //func pickerView(_ pickerView: AKPickerView, titleForItem item: Int) -> String {
      //  return images[item]
    //}
}

extension PetSelectionViewController: AKPickerViewDataSource{
    func numberOfItemsInPickerView(_ pickerView: AKPickerView) -> Int {
        return images.count
    }
}




