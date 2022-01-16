//
//  weld.swift
//  Builder
//
//  Created by matt kazan on 5/1/20.
//  Copyright © 2020 matt kazan. All rights reserved.
//

import Foundation
import SpriteKit
import SceneKit

class weld {

    var weldJoint : SKPhysicsJointFixed

    init(bodyA: SKPhysicsBody, bodyB: SKPhysicsBody, point: CGPoint){
        
        var anchorAPosition = point
        anchorAPosition.x += 0
        anchorAPosition.y += 50
        weldJoint = SKPhysicsJointFixed.joint(withBodyA: bodyA, bodyB: bodyB, anchor: anchorAPosition)
        //return(weldJoint)
        
        
    }
    
    func getJoint() -> SKPhysicsJointFixed
    {
        return weldJoint
    }
    
       
}
