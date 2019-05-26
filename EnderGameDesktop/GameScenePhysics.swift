//
//  GameScenePhysics.swift
//  EnderGameDesktop
//
//  Created by Miquel Mirat Soler on 26/05/2019.
//  Copyright © 2019 mmirat. All rights reserved.
//

import Foundation
import GameKit

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let a = contact.bodyA
        let b = contact.bodyB
        //print("contact!")
        //CONTACTO PLAYER-PORTAL
        if(a.categoryBitMask == Masks.player.rawValue && b.categoryBitMask == Masks.portal.rawValue ||
            a.categoryBitMask == Masks.portal.rawValue && b.categoryBitMask == Masks.player.rawValue){
            
            let portal:PortalNode? = a.categoryBitMask == Masks.portal.rawValue ? a.node as? PortalNode : b.node as? PortalNode
            portal!.didContactPlayer()
        }
        //CONTACT PLAYER-LIFE
        if(a.categoryBitMask == Masks.player.rawValue && b.categoryBitMask == Masks.life.rawValue ||
            a.categoryBitMask == Masks.life.rawValue && b.categoryBitMask == Masks.player.rawValue){
            //print("CONTACT PLAYER LIFE!")
            if soundsEnabled { self.run(SKAction.playSoundFileNamed("powerup_v2", waitForCompletion: false)) }
            lifes += 1
            
            let life:LifeNode? = a.categoryBitMask == Masks.life.rawValue ? a.node as? LifeNode : b.node as? LifeNode
            life!.removeFromParent()
        }
        
        
        //CONTACTO PLAYER-ENEMY
        if(a.categoryBitMask == Masks.player.rawValue && b.categoryBitMask == Masks.enemy.rawValue ||
            a.categoryBitMask == Masks.enemy.rawValue && b.categoryBitMask == Masks.player.rawValue){
            //si los sonidos estan activados
            if soundsEnabled { self.run(SKAction.playSoundFileNamed("lost-a-life", waitForCompletion: false)) }
            
            score -= 50
            lifes -= 1
            let enemy:EnemyNode? = a.categoryBitMask == Masks.enemy.rawValue ? a.node as? EnemyNode : b.node as? EnemyNode
            enemy?.removeFromParent()
            enemy?.isDeadBool = true
            enemiesEliminated += 1
        }
        
        //CONTACTO ENEMY-PORTAL
        if(a.categoryBitMask == Masks.portal.rawValue && b.categoryBitMask == Masks.enemy.rawValue ||
            a.categoryBitMask == Masks.enemy.rawValue && b.categoryBitMask == Masks.portal.rawValue){
            //print("enemy dies")
            let portal:PortalNode?
            let enemy:EnemyNode?
            if(a.categoryBitMask == Masks.portal.rawValue){
                portal = a.node as? PortalNode
                enemy = b.node as? EnemyNode
            }else{
                portal = b.node as? PortalNode
                enemy = a.node as? EnemyNode
            }
            
            if soundsEnabled { self.run(SKAction.playSoundFileNamed("lost-a-life", waitForCompletion: false)) }
            
            enemy?.removeFromParent()
            enemy?.isDeadBool = true
            enemiesEliminated += 1
            self.score += 10
            portal?.didAbsorveEnemy()
            
            
        }
    }
}
