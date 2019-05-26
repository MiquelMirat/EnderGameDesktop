//
//  CustomLabel.swift
//  EnderGameDesktop
//
//  Created by Miquel Mirat Soler on 26/05/2019.
//  Copyright © 2019 mmirat. All rights reserved.
//

import Cocoa
import GameKit


class CustomLabel: SKLabelNode {
    let fadeIn = SKAction.fadeAlpha(to: 1, duration: 0.8)
    
    func preConfigure(position:CGPoint, name:String) -> CustomLabel {
        self.fontName = "American Typewriter"
        self.zPosition = 4
        self.fontSize = 30
        self.fontColor = .white
        self.position = position
        self.name = name
        return self
    }
    func hide(){
        self.isHidden = true
        self.alpha = 0.0
    }
    func show(){
        self.isHidden = false
        self.run(fadeIn)
    }
    

}
