//
//  PlayerNode.swift
//  Ender Game
//
//  Created by Miquel Mirat Soler on 13/04/2019.
//  Copyright © 2019 mmirat. All rights reserved.
//

import Foundation
import GameplayKit


class PlayerNode: SKSpriteNode{
    var lifes:Int = 3
    
    func preConfigure(pos:CGPoint) -> PlayerNode {
        self.physicsBody = self.getCustomPhysicsBody(size: self.size)
        self.zPosition = 5
        self.position = pos
        self.setScale(0.07)
        return self
    }
    
    func getCustomPhysicsBody(size:CGSize) -> SKPhysicsBody{
        let physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width * 0.7, height: size.height * 0.7))
        physicsBody.affectedByGravity = false
        physicsBody.isDynamic = false
        physicsBody.categoryBitMask = Masks.player.rawValue
        physicsBody.collisionBitMask = 0
        physicsBody.contactTestBitMask = Masks.enemy.rawValue | Masks.portal.rawValue | Masks.life.rawValue
        physicsBody.allowsRotation = false
        return physicsBody
    }
    
    func update(target:CGPoint) {
        let dx:CGFloat = (self.position.x) - target.x
        let dy:CGFloat = (self.position.y) - target.y
        self.position.x -= dx * 0.1
        self.position.y -= dy * 0.1
    }
    
}
