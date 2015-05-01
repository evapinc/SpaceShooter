//
//  GameScene.swift
//  Game
//
//  Created by Nathan Croxton on 30/04/2015.
//  Copyright (c) 2015 evapinc. All rights reserved.
//

import SpriteKit

struct PhysicsCatagory {
    static let Enemy : UInt32 = 1
    static let Bullet : UInt32 = 2
    static let Player : UInt32 = 3
}



class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var Score = Int()
    
    
    var Player = SKSpriteNode(imageNamed: "Player.png")
    
    var ScoreLbl = UILabel()
    
    override func didMoveToView(view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        
        Player.position = CGPointMake(self.size.width/2, self.size.height/5)
        Player.physicsBody = SKPhysicsBody(rectangleOfSize: Player.size)
        Player.physicsBody?.affectedByGravity = false
        Player.physicsBody?.categoryBitMask = PhysicsCatagory.Player
        Player.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy
        Player.physicsBody?.dynamic = false
        self.addChild(Player)
        
        var Timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("SpawnBullets"), userInfo: nil, repeats: true)
        
        var enemyTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("SpawnEnemy"), userInfo: nil, repeats: true)
        
        
        ScoreLbl.text = "\(Score)"
        ScoreLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        ScoreLbl.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.3)
        ScoreLbl.textColor = UIColor.whiteColor()
        self.view?.addSubview(ScoreLbl)
        }
    
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        NSLog("Bullet Hit")
        var firstBody : SKPhysicsBody = contact.bodyA
        var secondBody : SKPhysicsBody = contact.bodyB
        
        if ((firstBody.categoryBitMask == PhysicsCatagory.Enemy) && (secondBody.categoryBitMask == PhysicsCatagory.Bullet) ||
            (firstBody.categoryBitMask == PhysicsCatagory.Bullet) && (secondBody.categoryBitMask == PhysicsCatagory.Enemy)){
            
            // #*#*#*#*#    |
            // #*#*#*#*#    |                                       |
            // #*#*#*#*#    |           Problem occuring Below      |
            // #*#*#*#*#    |                                       V
            // #*#*#*#*#    |

                
            // This is the line with the problem ('SKNode?' is not convertable to SKSpriteNode; did you mean to use 'as!' to force downcast?)
            CollisionWithBullet(firstBody.node as SKSpriteNode, Bullet: secondBody.node as SKSpriteNode)
        }
        
        else if ((firstBody.categoryBitMask == PhysicsCatagory.Enemy) && (secondBody.categoryBitMask == PhysicsCatagory.Player) ||
            (firstBody.categoryBitMask == PhysicsCatagory.Player) && (secondBody.categoryBitMask == PhysicsCatagory.Enemy)){
                
            // This is the line with the problem ('SKNode?' is not convertable to SKSpriteNode; did you mean to use 'as!' to force downcast?)
            CollisionWithPlayer(firstBody.node as SKSpriteNode, Player: secondBody.node as SKSpriteNode)
        }
        
        
    }
    
    func CollisionWithBullet(Enemy: SKSpriteNode, Bullet: SKSpriteNode) {
        NSLog("Collision Function")
        Enemy.removeFromParent()
        Bullet.removeFromParent()
        Score++
        NSLog("\(Score)")
        ScoreLbl.text = "\(Score)"
    }
    
    
    func CollisionWithPlayer(Enemy: SKSpriteNode, Player: SKSpriteNode){
        Enemy.removeFromParent()
        Player.removeFromParent()
        
        self.view?.presentScene(SKScene(fileNamed: "EndScene"))
        
    }
    
    
    func SpawnBullets(){
        
        var Bullet = SKSpriteNode(imageNamed: "Bullet.png")
        Bullet.zPosition = -5
        Bullet.position = CGPointMake(Player.position.x, Player.position.y)
        let action = SKAction.moveToY(self.size.height+50, duration: 1.3)
        let actionDone = SKAction.removeFromParent()
        Bullet.runAction(SKAction.sequence([action, actionDone]))
        Bullet.runAction(SKAction.repeatActionForever(action))
        
        Bullet.physicsBody = SKPhysicsBody(rectangleOfSize: Bullet.size)
        Bullet.physicsBody?.categoryBitMask = PhysicsCatagory.Bullet
        Bullet.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy
        Bullet.physicsBody?.affectedByGravity = false
        Bullet.physicsBody?.dynamic = false
        
        
        self.addChild(Bullet)
    }
    
    func SpawnEnemy() {
        
        var Enemy = SKSpriteNode(imageNamed: "Enemy.png")
        var minValue = self.size.width/8
        var maxValue = self.size.width - 20
        var spawnPoint = UInt32(maxValue - minValue)
        Enemy.position = CGPoint(x: CGFloat(arc4random_uniform(spawnPoint)), y: self.size.height)
        
        let action = SKAction.moveToY(-100, duration: 3)
        let actionDone = SKAction.removeFromParent()
        Enemy.runAction(SKAction.sequence([action, actionDone]))
        
        //Enemy.runAction(SKAction.repeatActionForever(action))
        
        Enemy.physicsBody = SKPhysicsBody(rectangleOfSize: Enemy.size)
        Enemy.physicsBody?.categoryBitMask = PhysicsCatagory.Enemy
        Enemy.physicsBody?.contactTestBitMask = PhysicsCatagory.Bullet
        Enemy.physicsBody?.affectedByGravity = false
        Enemy.physicsBody?.dynamic = true
        
        
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
