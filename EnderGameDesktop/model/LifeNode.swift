//
//  LifeNode.swift
//  Ender Game
//
//  Created by Miquel Mirat Soler on 16/04/2019.
//  Copyright © 2019 mmirat. All rights reserved.
//

//import UIKit
import GameplayKit

class LifeNode: SKSpriteNode {

    
    func preConfigure() -> LifeNode {
        self.setScale(0.04)
        self.physicsBody = self.getCustomPhysicsBody(size: self.size)
        self.zPosition = 1
        return self
    }
    
    func getCustomPhysicsBody(size:CGSize) -> SKPhysicsBody{
        let physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody.collisionBitMask = 0
        physicsBody.categoryBitMask = Masks.life.rawValue
        physicsBody.contactTestBitMask = Masks.player.rawValue
        physicsBody.affectedByGravity = false
        return physicsBody
    }
    
}
