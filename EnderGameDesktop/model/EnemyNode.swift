//
//  EnemyNode.swift
//  Ender Game
//
//  Created by Miquel Mirat Soler on 11/04/2019.
//  Copyright © 2019 mmirat. All rights reserved.
//

//import UIKit
import GameplayKit

class EnemyNode: SKSpriteNode {
    var isDeadBool :Bool = false
    var maxSpeed:CGFloat = 400
    
    func isDead()-> Bool {
        return self.isDeadBool
    }
    func setDead(){
        self.isDeadBool = true
    }
    
    func preConfigure() -> EnemyNode {
        self.setScale(0.02)
        
        self.zPosition = 2
        self.physicsBody = self.getCustomPhysicsBody(size: self.size)
        return self
    }
    
    
    func getCustomPhysicsBody(size:CGSize) -> SKPhysicsBody {
        let physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody.collisionBitMask = 0
        physicsBody.categoryBitMask = Masks.enemy.rawValue
        physicsBody.contactTestBitMask = Masks.portal.rawValue | Masks.player.rawValue
        physicsBody.affectedByGravity = false
        return physicsBody
    }
    
}
