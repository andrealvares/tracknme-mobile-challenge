//
//  File.swift
//  DevTrackNMe
//
//  Created by Thales Frigo on 01/12/17.
//  Copyright © 2017 Thales Frigo. All rights reserved.
//

import UIKit
import SpriteKit

class PersonScene: SKScene {
    
    var personFrames: [SKTexture]!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        self.backgroundColor = .white
        var frames: [SKTexture] = []
        
        let personAtlas = SKTextureAtlas(named: "Person")
        let rows = 0 ... 8
        let columns = 0 ... 7
        
        for column in columns {
            for row in rows {
                let textureName = "sprites-\(column)-\(row)"
                let texture = personAtlas.textureNamed(textureName)
                frames.append(texture)
            }
        }
        
        personFrames = frames
    }
    
    func walk(){
        let texture = personFrames[0]
        
        let person = SKSpriteNode(texture: texture)
        person.position = CGPoint(x: 25, y: 50)
        
        self.addChild(person)
        person.run(SKAction.repeatForever(SKAction.animate(with: personFrames, timePerFrame: 0.1, resize: false, restore: true)))
    }
}
