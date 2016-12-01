//
//  MiniGameTableViewButton.swift
//  SpiritPets
//
//  Created by Augusto Falcão on 11/30/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import Foundation
import UIKit

class MiniGameTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var index: Int
    
    init(myIndex: Int, style: UITableViewCellStyle, reuseIdentifier: String?) {
        index = myIndex
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    func setup() {
        backgroundImageView = UIImageView(image: MiniGameList.getBackgroundImageOf(index: index))
        nameLabel = UILabel()
        //nameLabel.text = "" //MiniGameList.getNameOf(index: index)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
