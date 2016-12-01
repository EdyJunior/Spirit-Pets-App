//
//  MiniGame02Bitmask.swift
//  SpiritPets
//
//  Created by Augusto Falcão on 11/30/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import Foundation

enum MiniGame02CategoryBitMasks: UInt32 {
    case none           = 0b00000000
    case player         = 0b00000001
    case enemy          = 0b00000010
    case bullet         = 0b00000100
    case friendlyBullet = 0b00001000
    case enemyBullet    = 0b00010000
}

enum MiniGame02ContactTestBitMasks: UInt32 {
    case none           = 0b00000000
    case player         = 0b00000001
    case enemy          = 0b00000010
    case bullet         = 0b00000100
    case friendlyBullet = 0b00001000
    case enemyBullet    = 0b00010000
}
