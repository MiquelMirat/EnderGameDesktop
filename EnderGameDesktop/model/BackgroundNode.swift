//
//  BackgroundNode.swift
//  EnderGameDesktop
//
//  Created by Miquel Mirat Soler on 26/05/2019.
//  Copyright © 2019 mmirat. All rights reserved.
//

import Cocoa
import GameKit

class BackgroundNode: SKSpriteNode {
    
    func preConfigure(size:CGSize) -> BackgroundNode{
        self.position = CGPoint(x:0,y:0)
        self.zPosition = 0
        self.size.height = size.height * 1.5
        self.size.width = size.width * 1.5
        return self
    }
    func update(pos:CGPoint){
        self.position.x = (pos.x * -1) * 0.4
        self.position.y = (pos.y * -1) * 0.4
    }
}
