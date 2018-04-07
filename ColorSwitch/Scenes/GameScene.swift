//
//  GameScene.swift
//  ColorSwitch
//
//  Created by Robin kamo on 2018-04-07.
//  Copyright © 2018 Robin kamo. All rights reserved.
//

import SpriteKit

enum PlayColors {
    static let colors = [
        UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0),
        UIColor(red: 241/255, green: 196/255, blue: 615/255, alpha: 1.0),
        UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0),
        UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
    ]
}

enum SwitchState: Int {
    case red, yellow, green, blue
}

class GameScene: SKScene {
    
    var colorSwitch : SKSpriteNode!
    var switchState = SwitchState.red
    var curentColorIndex: Int?
    

    override func didMove(to view: SKView) {
        setupPhysics()
        layoutScene()

    }
    
    func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
        physicsWorld.contactDelegate = self
    }
    
    func layoutScene(){
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        
        colorSwitch = SKSpriteNode(imageNamed: "ColorCircle")
        colorSwitch.size = CGSize(width: frame.size.width / 3, height: frame.size.width / 3)
        colorSwitch.position = CGPoint(x: frame.midX, y: frame.minY + colorSwitch.size.height)
        colorSwitch.physicsBody = SKPhysicsBody(circleOfRadius: colorSwitch.size.width/2)
        colorSwitch.physicsBody?.categoryBitMask = PhysicsCatergoies.switchCircel
        colorSwitch.physicsBody?.isDynamic = false
        
        
        addChild(colorSwitch)
        
        spawnBall()
    }
    
    func spawnBall() {
        curentColorIndex = Int(arc4random_uniform(UInt32(4)))
        
        
        let ball = SKSpriteNode(texture: SKTexture(imageNamed: "ball"), color: PlayColors.colors[curentColorIndex!], size: CGSize(width: 30, height: 30))
        ball.colorBlendFactor = 1.0
        ball.name = "Ball"
        ball.position = CGPoint(x: frame.midX, y: frame.maxY)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.categoryBitMask = PhysicsCatergoies.ballCategory
        ball.physicsBody?.contactTestBitMask = PhysicsCatergoies.switchCircel
        ball.physicsBody?.collisionBitMask = PhysicsCatergoies.none
        
        
        addChild(ball)
    }
    
    
    func turnWheel() {
        
        if let newState = SwitchState(rawValue: switchState.rawValue + 1){
            switchState = newState
        } else {
            switchState = .red
            
        }
        
        colorSwitch.run(SKAction.rotate(byAngle: .pi/2, duration: 0.25))
        
    }
    
    func gameOver() {
        print("game over")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        turnWheel()
        
    }
    
 
}



extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        
        if contactMask == PhysicsCatergoies.ballCategory | PhysicsCatergoies.switchCircel {
            if let ball = contact.bodyA.node?.name == "Ball" ? contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode {
                if curentColorIndex == switchState.rawValue {
                    ball.run(SKAction.fadeIn(withDuration: 0.25)) {
                        ball.removeFromParent()
                        self.spawnBall()
                    }
                }
            } else {
                gameOver()
            }
        
        
    }
    
}



}








