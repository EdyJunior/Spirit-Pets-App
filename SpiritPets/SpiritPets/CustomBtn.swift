//
//  CustomBtn.swift
//  SpiritPets
//
//  Created by Edvaldo Junior on 07/12/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import UIKit

class CustomBtn: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        
        let uiEdgeInsets = UIEdgeInsets(top: CGFloat(20), left: CGFloat(20), bottom: CGFloat(20), right: CGFloat(20))
        self.imageEdgeInsets = uiEdgeInsets
        self.layer.cornerRadius = self.frame.width / 2
    }

}
