//
//  Utils.swift
//  Ender Game
//
//  Created by Miquel Mirat Soler on 13/04/2019.
//  Copyright © 2019 mmirat. All rights reserved.
//

import Foundation
import GameplayKit
//import UIKit

class Utils {
    var ud:UserDefaults = UserDefaults.standard
    
    var isSoundEnabled:Bool = true
    //MARK: - User Defaults Management
    
    func saveIsSoundEnabled(isEnabled:Bool){
        self.isSoundEnabled = isEnabled
        ud.set(isEnabled, forKey: "isSoundEnabled")
    }
    func getIsSoundEnabled() -> Bool {
        let sound = ud.bool(forKey: "isSoundEnabled")
        self.isSoundEnabled = sound
        return sound
    }
    
    
    //Guarda el score si es mayor al actual
    func saveNewBestScore(score:Int){
        if score > getBestScore() {
            ud.set(score, forKey: "bestScore")
        }
    }
    
    //Trae el mejor score actual (si es nil devuelve 0)
    func getBestScore() -> Int{
        return ud.integer(forKey: "bestScore") 
    }
    
    //Mark: - CGPoint Randomizers
    
    //Genera un CGPoint aleatorio por el centro de la pantalla
    func randomInsidePosition(size:CGSize) -> CGPoint {
        let x:Int = Int.random(in: Int(-(size.width / 2) + 50) ... Int((size.width / 2) - 50))
        let y:Int = Int.random(in: Int(-(size.height / 2) + 50) ... Int((size.height / 2) - 50))
        return CGPoint(x: x, y: y)
    }
    
    //Genera un CPoint aleatorio a un radio definido fuera de la pantalla
    func randomOutsidePosition(spriteSize:CGSize,size:CGSize) -> CGPoint{
        let angle = (CGFloat(arc4random_uniform(360)) * CGFloat.pi) / 180.0
        let radius = (size.width >= size.height ? (size.width + spriteSize.width) : (size.height + spriteSize.height)) / 2
        return CGPoint(x: cos(angle) * radius,y: sin(angle) * radius)
    }
    
    
    func shouldSpawnLife(oldValue:Int,newValue:Int) -> Bool{
        if oldValue < 50 && newValue >= 50 ||
            oldValue < 100 && newValue >= 100 ||
            oldValue < 150 && newValue >= 150 ||
            oldValue < 200 && newValue >= 200 ||
            oldValue < 250 && newValue >= 250 ||
            oldValue < 300 && newValue >= 300
        {
            return true
        }else{
            return false
        }
        
    }
}
