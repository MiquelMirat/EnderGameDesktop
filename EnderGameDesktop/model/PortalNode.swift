//
//  PortalNode.swift
//  Ender Game
//
//  Created by Miquel Mirat Soler on 11/04/2019.
//  Copyright © 2019 mmirat. All rights reserved.
//

//import UIKit
import GameplayKit

class PortalNode: SKSpriteNode {
    
    //var maxSpeed: Float = 800
    //var lifeTime: Int = 3
    var maxAbsorvation: Int = 20
    var enemiesAbsorved: Int = 0 {
        didSet {
            if(self.enemiesAbsorved > self.maxAbsorvation){
                self.removeFromParent()
                self.isClosed = true
            }
        }
    }
    var isClosed:Bool = false
    
    
    
    //Lanzado cuando un enemigo contacta
    func didAbsorveEnemy(){
        self.enemiesAbsorved += 1
    }
    //Lanzado cuando el jugador contacta
    func didContactPlayer(){
        self.enemiesAbsorved += 12
    }
    
    func preConfigure() -> PortalNode {
        self.run(SKAction.rotate(byAngle: CGFloat(Double.random(in: 0...360)), duration:0))
        self.setScale(0.08)
        self.xScale = 0.04
        self.zPosition = 1
        self.physicsBody = getCustomPhysicsBody(size: self.size)
        return self
    }
    
    
    func getCustomPhysicsBody(size:CGSize) -> SKPhysicsBody {
        let physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody.collisionBitMask = 0
        physicsBody.categoryBitMask = Masks.portal.rawValue
        physicsBody.contactTestBitMask = Masks.player.rawValue | Masks.enemy.rawValue
        physicsBody.affectedByGravity = false
        physicsBody.allowsRotation = false
        physicsBody.pinned = false
        return physicsBody
        
    }
    
    
    
}
