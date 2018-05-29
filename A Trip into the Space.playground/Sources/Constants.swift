//
//  Constants.swift
//  game_wwdc2018
//
//  Created by Ernesto De Crecchio on 26/03/18.
//  Copyright © 2018 ernesto-de-crecchio. All rights reserved.
//

import SpriteKit

enum PhysicsMask {
  static let player: UInt32 = 0x1 << 1    // 2
  static let borders: UInt32 = 0x1 << 2    // 4
  static let asteroid: UInt32 = 0x1 << 3     // 8
  static let starterBorder: UInt32 = 0x1 << 4  // 16
  static let removedAsteroid: UInt32 = 0x1 << 5 //32
}

enum Z {
  static let background: CGFloat = -10.0
  static let player: CGFloat = 10
  static let decorations: CGFloat = 20
  static let HUD: CGFloat = 100.0
  static let Mars: CGFloat = -9
  static let Clouds: CGFloat = 12
}
