//
//  brick.swift
//  Builder
//
//  Created by matt kazan on 4/30/20.
//  Copyright © 2020 matt kazan. All rights reserved.
//

import Foundation
import SpriteKit
class brick: NSObject {
    var point: CGPoint
    var b: SKSpriteNode
    init(point: CGPoint, b: SKSpriteNode) {
        self.point = point
        self.b = b
    }
    func getPoint() -> CGPoint {
        return point
    }
    func getSprite() -> SKSpriteNode {
        return b
    }
    
    
}
