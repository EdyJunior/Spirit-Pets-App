//
//  MiniGamesList.swift
//  SpiritPets
//
//  Created by Augusto Falcão on 11/30/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import Foundation
import UIKit

class MiniGameList {
    
    static let nameArray = ["MiniGame 01", "MiniGame 02"]
    static let backgroundImageArray = [#imageLiteral(resourceName: "MiniGame_01"), #imageLiteral(resourceName: "MiniGame_02")]
    
    static func getNameOf(index: Int) -> String {
        return nameArray[index]
    }
    
    static func getBackgroundImageOf(index: Int) -> UIImage {
        return backgroundImageArray[index]
    }
}
