//
//  GameScene.swift
//  Game
//
//  Created by Nathan Croxton on 30/04/2015.
//  Copyright (c) 2015 evapinc. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    
    
    var Player = SKSpriteNode(imageNamed: "Player.png")
    
    override func didMoveToView(view: SKView) {
        self.addChild(Player)
        Player.position = CGPointMake(self.size.width/2, self.size.height/5)
        var Timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("SpawnBullets"), userInfo: nil, repeats: true)
        
        var enemyTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("SpawnEnemy"), userInfo: nil, repeats: true)
        
        //var enemyTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("SpawnEnemy", userInfo: nil, repeats: true)
    }
    
    func SpawnBullets(){
        
        var Bullet = SKSpriteNode(imageNamed: "Bullet.png")
        Bullet.zPosition = -5
        Bullet.position = CGPointMake(Player.position.x, Player.position.y)
        self.addChild(Bullet)
        let action = SKAction.moveToY(self.size.height+50, duration: 1)
        Bullet.runAction(SKAction.repeatActionForever(action))
    }
    
    func SpawnEnemy() {
        
        var Enemy = SKSpriteNode(imageNamed: "Enemy.png")
        var minValue = self.size.width/8
        var maxValue = self.size.width - 20
        var spawnPoint = UInt32(maxValue - minValue)
        Enemy.position = CGPoint(x: CGFloat(arc4random_uniform(spawnPoint)), y: self.size.height)
        
        let action = SKAction.moveToY(-100, duration: 3)
        Enemy.runAction(SKAction.repeatActionForever(action))
        
        self.addChild(Enemy)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            Player.position.x = location.x
           
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            Player.position.x = location.x
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
