//
//  GameScene.swift
//  Builder
//
//  Created by matt kazan on 4/30/20.
//  Copyright © 2020 matt kazan. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit
import SceneKit
import AVFoundation
 
class GameScene: SKScene {
    
    var player: AVAudioPlayer?

    let startLabel = SKLabelNode()
    let resetLabel = SKLabelNode()
    let weldLabel = SKLabelNode()
    
    let windMeter = SKLabelNode()
    let heightMeter = SKLabelNode()
    let timeLabel = SKLabelNode()
    
    let buttonBack = SKSpriteNode(color: UIColor.green, size: CGSize(width: 150, height: 60))
    let buttonBackR = SKSpriteNode(color: UIColor.yellow, size: CGSize(width: 100, height: 40))
    let buttonBackWeld = SKSpriteNode(color: UIColor.yellow, size: CGSize(width: 100, height: 40))
    
    let buttonBackH = SKSpriteNode(color: UIColor.green, size: CGSize(width: 220, height: 36))
    let buttonBackW = SKSpriteNode(color: UIColor.green, size: CGSize(width: 220, height: 36))

    var windSpeed = 0.0;
    var camOffset = 0;
    var height = 0.0
    var time = 0.0
    var physics = false
    var allowsCameraControl =  true
    var weldingOn = false
    
    struct PhysicsCategory {
        static let none      : UInt32 = 0
        static let all       : UInt32 = UInt32.max
        static let brick     : UInt32 = 0b1
        static let ground    : UInt32 = 0b10
       // 2
    }
    
    var bricks = Array<brick>()
    var welds = Array<weld>()
    var selection = Array<brick>()
    let ground = SKSpriteNode(color: UIColor.white, size: CGSize(width: 500, height: 40))

   

    override func didMove(to view: SKView) {
        
        ground.size = CGSize(width: 500000, height: 40)
        ground.position = CGPoint(x: 0, y: -self.size.height * 0.4)
        addChild(ground)
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size) // 1
        ground.physicsBody?.isDynamic = false // 2
        ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
        
        backgroundColor = SKColor.gray
       
        physicsWorld.gravity = CGVector(dx: 0, dy:-9.8)
        physicsWorld.contactDelegate = self
        
        
       
        startLabel.text = ("Start")
        startLabel.fontSize = 50
        startLabel.fontColor = SKColor.black
        startLabel.fontName = "Menlo-bold"
        startLabel.position = CGPoint(x: self.size.width/3.5, y: self.size.height/3)
        startLabel.zPosition = 5
        addChild(startLabel)
        buttonBack.position = (CGPoint(x: self.size.width/3.5, y: self.size.height/2.9))
        addChild(buttonBack)
        
        resetLabel.text = ("Reset")
        resetLabel.fontSize = 30
        resetLabel.fontColor = SKColor.black
        resetLabel.fontName = "Menlo-bold"
        resetLabel.position = CGPoint(x: self.size.width/3.5, y: self.size.height/3.57)
        resetLabel.zPosition = 5
        addChild(resetLabel)
        buttonBackR.position = (CGPoint(x: self.size.width/3.5, y: self.size.height/3.5))
        addChild(buttonBackR)
        
        weldLabel.text = ("Weld")
        weldLabel.fontSize = 30
        weldLabel.fontColor = SKColor.black
        weldLabel.fontName = "Menlo-bold"
        weldLabel.position = CGPoint(x: self.size.width/3.5, y: self.size.height/4.5)
        weldLabel.zPosition = 5
        addChild(weldLabel)
        buttonBackWeld.position = (CGPoint(x: self.size.width/3.5, y: self.size.height/4.34))
        addChild(buttonBackWeld)
        
        heightMeter.text = "Height: " + (String(height))
        heightMeter.fontSize = 30
        heightMeter.fontColor = SKColor.black
        heightMeter.fontName = "Menlo-bold"
        heightMeter.position = CGPoint(x: -self.size.width/3.7, y: self.size.height/3.5)
        heightMeter.zPosition = 5
        addChild(heightMeter)
        buttonBackH.position = (CGPoint(x: -self.size.width/3.7, y: self.size.height/3.4))
        addChild(buttonBackH)
        
        timeLabel.text = (String(Int(time)))
        timeLabel.fontSize = 30
        timeLabel.fontColor = SKColor.black
        timeLabel.fontName = "Menlo-bold"
        timeLabel.position = CGPoint(x: -self.size.width/3.7, y: self.size.height/4)
        addChild(timeLabel)

        
        wind()
        
        
        for b in bricks {
            b.getSprite().position.x += CGFloat(camOffset)
            b.getSprite().physicsBody?.applyForce(CGVector(dx: 5.0, dy: 5.0))
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        var hBool = false
        for b in bricks {
            //height = 0

            let dist = high(point1: b.getSprite().position, point2: ground.position)
            //print(dist)
            if !dist.isLessThanOrEqualTo(CGFloat(height)) && physics {
                for bR in bricks{
                    if bR == b {}
                    else if getDistanceSquared(p1: bR.getSprite().position, p2: b.getSprite().position) < 1800 {
                        hBool = true
                    }
                    else {
                        hBool = false
                    }
                }
                if hBool {
                    height = Double(high(point1: b.getSprite().position, point2: ground.position))
                    heightMeter.text = "Height: " + (String(Int(height)))
                }
               

            }
            if height > 100 {
                b.getSprite().physicsBody?.applyImpulse(CGVector(dx: windSpeed, dy: 0))

            }
            

        }
        time += 1/60 //worst line of code i have ever written
        timeLabel.text = (String(Int(selection.count)))
        //print(time)
        if((Int(time) % 5) == 0 && height > 100){
            windSpeed = Double.random(in: -0.53...0.53)

        }
        
        welding()
        heightMeter.text = "Height: " + (String(Int(height)))

        windMeter.text = ("Wind: ") + String(format: "%.2f",windSpeed)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var bool = false
        for touch in touches {
            for b in bricks {
                if b.getSprite().contains(touch.location(in: self)) {
                    bool = true
                }
            }
            let touchPoint = touch.location(in: self)

            if !bool && !startLabel.contains(touchPoint) && !resetLabel.contains(touchPoint) && !weldLabel.contains(touchPoint){
                bricks.append(brick(point: touch.location(in: self),
                                        b: SKSpriteNode(color: UIColor.yellow, size: CGSize(width: 80, height: 40))))
                bricks[bricks.count-1].getSprite().position = bricks[bricks.count-1].getPoint()
                addChild(bricks[bricks.count-1].getSprite())
                MusicHelper.sharedHelper.clang()
                if physics {
                    let b = bricks[bricks.count-1]
                    b.getSprite().physicsBody = SKPhysicsBody(rectangleOf: b.getSprite().size)
                    b.getSprite().physicsBody?.isDynamic = true // 2
                    b.getSprite().physicsBody?.categoryBitMask = PhysicsCategory.brick
                }
                else {
                    let b = bricks[bricks.count-1]
                    b.getSprite().physicsBody = SKPhysicsBody(rectangleOf: b.getSprite().size)
                    b.getSprite().physicsBody?.isDynamic = false // 2
                    b.getSprite().physicsBody?.categoryBitMask = PhysicsCategory.brick
                }
                
            }
            if touch.location(in: self).x > (self.size.width/3 + CGFloat(camOffset)) && camOffset < 1000 {
                //print(camOffset)
                camOffset = -5

            }
            else if touch.location(in: self).x < (-self.size.width/3 - CGFloat(camOffset)) && camOffset > -1000{
                camOffset = 5

                //print(camOffset)

            }
            for b in bricks {
                b.getSprite().position.x += CGFloat(camOffset)
            }
        }
        
        
       
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            for b in bricks {
                if b.getSprite().contains(touch.location(in: self)) {
                    b.getSprite().physicsBody?.isDynamic = false // 2
                    b.getSprite().position = touch.location(in: self)
                    if physics {
                        b.getSprite().physicsBody?.isDynamic = true // 2

                    }

                }
            }
            if touch.location(in: self).x > self.size.width/3 + CGFloat(camOffset) {
                //print(camOffset)
                camOffset = -5
            }
            else if touch.location(in: self).x < -self.size.width/3 - CGFloat(camOffset) {
                camOffset = 5
                //print(camOffset)

            }
            for b in bricks {
                b.getSprite().position.x += CGFloat(camOffset)
            }
        }
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let touchPoint = touch.location(in: self)
            
            if startLabel.contains(touchPoint) && !physics {
                for b in bricks {
                    b.getSprite().physicsBody?.isDynamic = true // 2
                }
                
                physics = true
                startLabel.text = ("Stop")
                buttonBack.color = UIColor.red


            }
                
            else if startLabel.contains(touchPoint) && physics {
                for b in bricks {
                    b.getSprite().physicsBody?.isDynamic = false
                }
                
                physics = false
                startLabel.text = ("Start")
                buttonBack.color = UIColor.green


            }
            
            else if weldLabel.contains(touchPoint) && !weldingOn {
                weldingOn = true
                buttonBackWeld.color = UIColor.red

            }
            else if weldLabel.contains(touchPoint) && weldingOn {
                weldingOn = false
                buttonBackWeld.color = UIColor.yellow

            }
            if resetLabel.contains(touchPoint)  {
                reset()
                physics = false
                startLabel.text = ("Start")
                buttonBack.color = UIColor.green
            }
            for b in bricks {
                if(b.getSprite().contains(touchPoint) && weldingOn ) {
                    selection.append(b)
                    while(selection.count > 2)
                    {
                        selection.remove(at: 0)
                    }
                }
            }
        }
        camOffset = 0
    }
    
    func welding() {
        if selection.count == 2 && weldingOn{
            welds.append(weld(bodyA: (selection[0].getSprite().physicsBody)!, bodyB: selection[1].getSprite().physicsBody!, point: CGPoint(x: 0, y: 0)))
            scene!.physicsWorld.add(welds[welds.count-1].getJoint())
            weldingOn = false
            buttonBackWeld.color = UIColor.yellow
            selection.removeAll()

        }
        
    }
    
    func wind() {
        //windSpeed = Double.random(in: -....3.14159)

        windMeter.text = ("Wind: ") + String(windSpeed)
        windMeter.fontSize = 30
        windMeter.fontColor = SKColor.black
        windMeter.fontName = "Menlo-bold"
        windMeter.position = CGPoint(x: -self.size.width/3.7, y: self.size.height/3)
        windMeter.zPosition = 5
        addChild(windMeter)
        buttonBackW.position = (CGPoint(x: -self.size.width/3.7, y: self.size.height/2.9))
        addChild(buttonBackW)
    }
    func high(point1: CGPoint, point2: CGPoint) -> CGFloat {
        return abs((abs(point1.y+self.size.height * 0.4) - abs(point2.y+self.size.height * 0.4)))
    }
    func getDistanceSquared(p1: CGPoint, p2: CGPoint) -> CGFloat {
        return pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2);
    }
    func reset() {
        for b in bricks {
            b.getSprite().physicsBody = nil
            b.getSprite().removeFromParent()
        }
        for w in welds{
            scene!.physicsWorld.remove(w.getJoint())
        }
        welds.removeAll()
        bricks.removeAll()
        selection.removeAll()
        height = 0
        camOffset = 0
        windSpeed = 0
        print(bricks.count)
        height = 0
        heightMeter.text = "0"
        weldingOn = false
        physics = false
        buttonBackWeld.color = UIColor.yellow
        buttonBack.color = UIColor.green


        
    }
}
extension GameScene: SKPhysicsContactDelegate {
    
   }
