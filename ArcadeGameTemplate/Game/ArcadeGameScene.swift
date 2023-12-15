//
//  ArcadeGameScene.swift
//  ArcadeGameTemplate
//

import SpriteKit
import SwiftUI
import UIKit


class Obstacle: SKSpriteNode {
    var contactOccurred: Bool = false
    init(texture: SKTexture, size: CGSize) {
           super.init(texture: texture, color: .clear, size: size)

       }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Toilet: SKSpriteNode{
    var contactOccurred: Bool = false
    //var inContact = Bool = false
    init(texture: SKTexture, size: CGSize) {
           super.init(texture: texture, color: .clear, size: size)

       }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeTextureWithAnimation(newTexture: SKTexture) {
            let fadeOut = SKAction.fadeOut(withDuration: 0.1)
            let changeTexture = SKAction.setTexture(newTexture)
            let fadeIn = SKAction.fadeIn(withDuration: 0.1)
            let sequence = SKAction.sequence([changeTexture])
            
            self.run(sequence)
        }
    
}

class Treasure: SKSpriteNode{
    
    init(texture: SKTexture, size: CGSize) {
           super.init(texture: texture, color: .clear, size: size)

       }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class Castle: SKNode {
    let castle: SKSpriteNode
    let cloud: SKSpriteNode
    
    init(spriteCastleTexture: SKTexture, sizeCastle: CGSize, spriteCloudTexture: SKTexture, sizeCloud: CGSize) {
        // Initialize the sprites
        castle = SKSpriteNode(texture: spriteCastleTexture, size: sizeCastle)
        cloud = SKSpriteNode(texture: spriteCloudTexture, size: sizeCloud)
        
        
        // Add the sprites to the node
        super.init()
        cloud.position = CGPoint(x: 0, y: -sizeCastle.height / 2 - sizeCloud.height / 2)

        addChild(cloud)

        addChild(castle)
        

        
        // Customize the physics body properties as needed
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }}

let bounceInOutAnimation = SKAction.sequence([
    SKAction.scale(to: 1.1, duration: 0.05),
    SKAction.scale(to: 1, duration: 0.3)
])

class ArcadeGameScene: SKScene, SKPhysicsContactDelegate {
    
    var isDarkMode = false

    var CastleExists = false
    
    var gameLogic: ArcadeGameLogic = ArcadeGameLogic.shared
    
    var obstaclesCreated = 0
    var canJump: Bool = true
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var comboLabel: SKLabelNode!
    var princessQuote: SKLabelNode!
    var onCloud = false
    var QuoteOn = false
    var movingWith: SKSpriteNode!
    var isCastleTime: Bool = true
    
    var lastScored : Int = 0
    var lastJump : Int = 0
    var previousJump : Int = 0
    var lastjumpScored : [Int: Int] = [:]
    var comboMultipl: Int = 0
    
    // UI
    private let verticalPadding: CGFloat = 60
    private let horizontalPadding: CGFloat = 16
    
    override func didMove(to view: SKView) {
        self.setUpGame()
        
        self.view?.showsPhysics = true

        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -100)
        createBackground()
        createPlayer()
        //createGround()
        spawnObstacles()
        setConstraints()
        //createCastle()
        

        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.fontName = "PressStart2P-Regular"
        scoreLabel.fontSize = 12
        scoreLabel.fontColor = isDarkMode ? UIColor.white : UIColor.black
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: self.horizontalPadding, y: self.frame.height - self.verticalPadding)
        self.addChild(scoreLabel)
        
        comboLabel = SKLabelNode(text: "Combo: x0")
        comboLabel.fontName = "PressStart2P-Regular"
        comboLabel.fontSize = 12
        comboLabel.fontColor = isDarkMode ? UIColor.white : UIColor.black
        comboLabel.horizontalAlignmentMode = .right
        comboLabel.position = CGPoint(x: self.frame.width - self.horizontalPadding, y: self.frame.height - self.verticalPadding)
        self.addChild(comboLabel)
        
        self.playSound(sound: ArcadeGameScene.startGameSound)
    }
    
    
    
    func createBackground() {
        
        /*
         // Create a blue sky
         let skyColor = SKColor(red: 135.0/255.0, green: 206.0/255.0, blue: 250.0/255.0, alpha: 1.0)
         self.backgroundColor = skyColor
         
         // Create and add clouds to the scene
         let cloudTexture = SKTexture(imageNamed: "pixel_cloud")
         let cloudSize = CGSize(width: 200, height: 100)
         
         // Create three clouds and position them on the scene
         
         let cloudNode = SKSpriteNode(texture: cloudTexture, size: cloudSize)
         cloudNode.position = CGPoint(x: CGFloat.random(in: 0...size.width), y: size.height)
         cloudNode.zPosition = -1
         addChild(cloudNode)
         let moveDownAction = SKAction.moveBy(x: 0, y: -self.size.height - cloudSize.height, duration: 5.0)
         let removeAction = SKAction.removeFromParent()
         let sequenceAction = SKAction.sequence([moveDownAction, removeAction])
         
         // Run the sequence action on the cloud
         cloudNode.run(sequenceAction)
         
         // Schedule the creation of the next cloud
         let waitAction = SKAction.wait(forDuration: 2.0)  // Adjust the duration as needed
         let createNextCloudAction = SKAction.run { [weak self] in
         self?.createBackground()
         }
         let sequence = SKAction.sequence([waitAction, createNextCloudAction])
         run(sequence)*/
        
     
        let skyColor1 = SKColor(red: 99.0/255.0, green: 206.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        let skyColor3 = SKColor(red: 29.0/255.0, green: 139.0/255.0, blue: 188.0/255.0, alpha: 1.0)

         
        //Version1
        if !isDarkMode{
            
            let background = SKSpriteNode(color: skyColor1, size: CGSize(width: size.width, height: size.height))
            background.name = "backgroundColor"
            background.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
            background.zPosition = -2
            addChild(background)}
        else{
            let background = SKSpriteNode(color: skyColor3, size: CGSize(width: size.width, height: size.height))
            background.name = "backgroundColor"
            background.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
            background.zPosition = -2
            addChild(background)
        }

      /*  let skyColor2 = SKColor(red: 28.0/255.0, green: 160.0/255.0, blue: 219.0/255.0, alpha: 1.0)
        let skyColor3 = SKColor(red: 29.0/255.0, green: 139.0/255.0, blue: 188.0/255.0, alpha: 1.0)
        let backgroundColor1 = SKSpriteNode(color: skyColor1, size: CGSize(width: size.width, height: size.height/3))
        

         backgroundColor2 = SKSpriteNode(color: skyColor2, size: CGSize(width: size.width, height: size.height/3))
        let backgroundColor3 = SKSpriteNode(color: skyColor3, size: CGSize(width: size.width, height: size.height/3))
        let clouds = SKSpriteNode(texture: SKTexture(imageNamed: "white_clouds"), size: CGSize(width: size.width, height: size.height))
        backgroundColor1.name = "backgroundColor"
        backgroundColor1.position = CGPoint(x: size.width * 0.5, y: size.height * 0.9)
        backgroundColor2.name = "backgroundColor"
        backgroundColor2.position = CGPoint(x: size.width * 0.5, y: size.height * 0.50)
        backgroundColor3.name = "backgroundColor"
        backgroundColor3.position = CGPoint(x: size.width * 0.5, y: size.height * 0)
        backgroundColor1.zPosition = -2
        backgroundColor2.zPosition = -2
        backgroundColor3.zPosition = -2
        clouds.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        clouds.zPosition = -1
        addChild(backgroundColor1)
        addChild(backgroundColor2)
        addChild(backgroundColor3)
        addChild(clouds)*/
         
        
        
    }
    
    func backgroundSwitch(){
        
        for node in self.children {
            if let spriteNode = node as? SKSpriteNode, spriteNode.name == "backgroundColor" {
                let screenHeight = self.size.height
                           let switchOffset = screenHeight / 3.0

                           // Check if the node is close to the expected position and switch accordingly
                           if abs(spriteNode.position.y - screenHeight * 0.9) < switchOffset {
                               withAnimation(.spring()){
                                   spriteNode.position.y = screenHeight * 0.5}
                           } else if abs(spriteNode.position.y - screenHeight * 0.5) < switchOffset {
                               withAnimation(.spring()){
                                   
                                   spriteNode.position.y = screenHeight * 0.0}
                           } else if abs(spriteNode.position.y - screenHeight * 0.0) < switchOffset {
                               withAnimation(.spring()){
                                   
                                   spriteNode.position.y = screenHeight * 0.9}
                           }        }
        }
        
        
    }
    
    
    
    func createPlayer() {
        player = SKSpriteNode(texture: SKTexture(imageNamed: "character"), size: CGSize(width: 50, height: 50))
        player.position = CGPoint(x: size.width * 0.5, y: size.height)
        player.name = "player"
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.categoryBitMask = 1
        player.physicsBody?.collisionBitMask = 1
        player.physicsBody?.contactTestBitMask = 1
        player.physicsBody?.collisionBitMask=1
        player.physicsBody?.isDynamic = true
        player.physicsBody?.allowsRotation = false
        
        addChild(player)
    }
    
    
    
    func spawnObstacles() {
        
        let wait = SKAction.wait(forDuration: 1.3)
        let waitComposed = SKAction.wait(forDuration: 2.8)

        let spawnRight = SKAction.run {
            if(self.isCastleTime == false){
                
                self.createObstacleRight()}
        }
        let spawnLeft = SKAction.run {
            if(self.isCastleTime == false){
                
                self.createObstacleLeft()}
        }
        let newCastle = SKAction.run {
            if self.isCastleTime {
                self.createCastle()
            }

        }
        let removeCastle = SKAction.run {
            self.removeCastle()
        }

        
        let sequence = SKAction.sequence([wait, spawnRight, wait, spawnLeft])
        let repeatForever = SKAction.repeatForever(sequence)
        
        
        let sequence2 = SKAction.sequence([newCastle, waitComposed])
        let repeatForever2 = SKAction.repeatForever(sequence2)
        run(repeatForever2)

        run(repeatForever)
    }
    
    func princessQuotation() {
        QuoteOn = true

        let princessQuote = SKLabelNode(text: "Princess")
        princessQuote.fontName = "PressStart2P-Regular"
        princessQuote.fontSize = 24
        princessQuote.fontColor = UIColor.black
        princessQuote.position = CGPoint(x: size.width / 2, y: size.height - 200)
        princessQuote.alpha = 0 // Start with an invisible label
        addChild(princessQuote)

        // Define the actions
        let fadeIn = SKAction.fadeIn(withDuration: 2)
        let wait = SKAction.wait(forDuration: 2)
        let fadeOut = SKAction.fadeOut(withDuration: 1)
        let remove = SKAction.removeFromParent()

        // Create a sequence of actions
        let princessSequence = SKAction.sequence([wait, fadeIn, wait, fadeOut, remove])

        // Run the sequence on the label
        princessQuote.run(princessSequence) {
            if(self.onCloud==false){
                self.QuoteOn = false}
        }
    }
    
   
    
    func createCastle(){

        
        if CastleExists == false{
            CastleExists=true
            let castle = SKSpriteNode(texture: SKTexture(imageNamed: "Castle"), size: CGSize(width: 100, height: 200))
            let cloud = SKSpriteNode(texture: SKTexture(imageNamed: "cloudCastle"), size: CGSize(width: 150, height: 50))
            
            
            castle.position = CGPoint(x: size.width*0.5, y: size.height)
            castle.zPosition = -1
            cloud.position = CGPoint(x: size.width*0.5, y: castle.position.y-100)
            cloud.name = "castle"
            castle.name = "cloud"
            // Add a physical body to the sprite with a body
            cloud.physicsBody = SKPhysicsBody(rectangleOf: cloud.size)
            cloud.physicsBody?.isDynamic = false
            cloud.physicsBody?.categoryBitMask = 3
            cloud.physicsBody?.contactTestBitMask = 1
            cloud.physicsBody?.collisionBitMask = 4
            
            addChild(castle)
            addChild(cloud)
            
            let moveDownCastle = SKAction.moveTo(y: size.height * 0.5, duration: 3.0)
            let moveDownCloud = SKAction.moveTo(y: (size.height * 0.5)-100, duration: 3.0)
            let moveDownCastle2 = SKAction.moveTo(y: 0, duration: 2)
            let moveDownCloud2 = SKAction.moveTo(y: -100, duration: 2)
            let waitComposed = SKAction.wait(forDuration: 2)


            
            
            let remove =  SKAction.removeFromParent()

            
            
            
            let castleSequence = SKAction.sequence([moveDownCastle, waitComposed])
            let cloudSequence = SKAction.sequence([moveDownCloud, waitComposed])
            let castleSequence2 = SKAction.sequence([moveDownCastle2, remove])
            let cloudSequence2 = SKAction.sequence([moveDownCloud2, remove])
            castle.run(castleSequence)
            cloud.run(cloudSequence){
                self.CastleExists=false
                self.isCastleTime=false
                castle.run(castleSequence2)
                cloud.run(cloudSequence2)
            }
            
            

        }
     
    }
    
    func removeCastle(){
        for node in self.children {
            // Check if the node has a specific name
            if let nodeName = node.name {
                if nodeName == "castle" || nodeName == "cloud" {
                    // Remove the node from the scene
                    node.removeFromParent()
                }
            }    }}
    
    func createGround() {
        let ground = SKSpriteNode(color: .green, size: CGSize(width: 60, height: 50))
        ground.position = CGPoint(x: size.width * 0.5, y: size.height * 0.1)
        ground.name = "ground"
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = 3
        ground.physicsBody?.contactTestBitMask = 1
        
        
        addChild(ground)
        
        
        let moveup=SKAction.moveTo(y: size.height/2, duration: 3)
        let movedown=SKAction.moveTo(y: size.height/4, duration: 3)
        let wait=SKAction.wait(forDuration: 5)
        let remove = SKAction.removeFromParent()
        
        ground.run(SKAction.repeatForever(SKAction.sequence([moveup, movedown])))
        ground.run(SKAction.sequence([wait, remove]))
        
        
    }
 
   
    
    func createObstacleRight() {
        
        
        
        let obstacle = Obstacle(texture: SKTexture(imageNamed: "MetalPipe right"), size: CGSize(width: CGFloat(150), height: 50))
        obstacle.name = "obstacle" + String(obstaclesCreated)
        obstacle.position = CGPoint(x: size.width * CGFloat.random(in: 0.85...1), y: size.height)
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.categoryBitMask = 3
        obstacle.physicsBody?.contactTestBitMask = 1
        obstaclesCreated+=1
        if (obstaclesCreated % 20 == 0 && obstaclesCreated != 0){
            isCastleTime = true
        }
        else{
            isCastleTime = false
        }
        
        let toilet = Toilet(texture: SKTexture(imageNamed: "openToilet2"), size: CGSize(width: CGFloat(40), height: 60))
        toilet.name = "toilet" + String(obstaclesCreated)
        toilet.position = CGPoint(x: CGFloat.random(in: obstacle.position.x-50...size.width), y: obstacle.position.y+50)
        toilet.physicsBody = SKPhysicsBody(rectangleOf: toilet.size)
        toilet.physicsBody?.isDynamic = false
        toilet.physicsBody?.categoryBitMask = 3
        toilet.physicsBody?.contactTestBitMask = 1
        toilet.physicsBody?.collisionBitMask=2

        addChild(obstacle)
        addChild(toilet)
        
        let moveDownOb = SKAction.moveTo(y: -obstacle.size.height * 0.5, duration: 3.0)
        let moveDownToilet = SKAction.moveTo(y: -toilet.size.height * 0.5, duration: 3.2)
        
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveDownOb, remove])
        let sequenceToilet = SKAction.sequence([moveDownToilet, remove])
        let combo = self.gameLogic.currentCombo
        
        if (combo % 5 == 0 && combo != 0) {
            let treasure = Treasure(texture: SKTexture(imageNamed: "tile_0067"), size: CGSize(width: 30, height: 30))
            
            treasure.position = CGPoint(x: CGFloat.random(in: obstacle.position.x-300...obstacle.position.x-150), y: obstacle.position.y)
            
            treasure.physicsBody = SKPhysicsBody(rectangleOf: treasure.size)
            treasure.physicsBody?.isDynamic = false
            treasure.physicsBody?.categoryBitMask = 4
            treasure.physicsBody?.contactTestBitMask = 1
            treasure.physicsBody?.collisionBitMask=3
            
            addChild(treasure)
            let moveDownTreasure = SKAction.moveTo(y: -obstacle.size.height * 0.5, duration: 3.0)
            let sequenceTreasure = SKAction.sequence([moveDownTreasure, remove])
            
            treasure.run(sequenceTreasure)
        }
        
        obstacle.run(sequence)
        toilet.run(sequenceToilet)
    }
    
    
    func createObstacleLeft() {
        
        let obstacle = Obstacle(texture: SKTexture(imageNamed: "MetalPipe left"), size: CGSize(width: CGFloat(150), height: 50))
        obstacle.name = "obstacle" + String(obstaclesCreated)
        obstacle.position = CGPoint(x: size.width * CGFloat.random(in: -0.10...0.15), y: size.height)
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.categoryBitMask = 3
        obstacle.physicsBody?.contactTestBitMask = 1
        obstaclesCreated+=1
        if (obstaclesCreated % 20 == 0 && obstaclesCreated != 0){
            isCastleTime = true
        }
        else{
            isCastleTime = false
        }


        let toilet = Toilet(texture: SKTexture(imageNamed: "openToilet2"), size: CGSize(width: CGFloat(40), height: 60))
        toilet.name = "toilet" + String(obstaclesCreated)

        toilet.position = CGPoint(x: CGFloat.random(in: 0...obstacle.position.x+50), y: obstacle.position.y+50)
        toilet.physicsBody = SKPhysicsBody(rectangleOf: toilet.size)
        toilet.physicsBody?.isDynamic = false
        toilet.physicsBody?.categoryBitMask = 3
        toilet.physicsBody?.contactTestBitMask = 1
        toilet.physicsBody?.collisionBitMask=2
        
        addChild(obstacle)
        addChild(toilet)

        
        
        let moveDownOb = SKAction.moveTo(y: -obstacle.size.height * 0.5, duration: 3.0)
        let moveDownToilet = SKAction.moveTo(y: -toilet.size.height * 0.5, duration: 3.2)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveDownOb, remove])
        let sequenceToilet = SKAction.sequence([moveDownToilet, remove])
        let combo = self.gameLogic.currentCombo

        if (combo % 5 == 0 && combo != 0) {
            let treasure = Treasure(texture: SKTexture(imageNamed: "tile_0067"), size: CGSize(width: 30, height: 30))
            treasure.position = CGPoint(x: CGFloat.random(in: obstacle.position.x+150...obstacle.position.x+300), y: obstacle.position.y)
            treasure.physicsBody = SKPhysicsBody(rectangleOf: treasure.size)
            treasure.physicsBody?.isDynamic = false
            treasure.physicsBody?.categoryBitMask = 4
            treasure.physicsBody?.contactTestBitMask = 1
            treasure.physicsBody?.collisionBitMask=3
            
            addChild(treasure)
            
            let moveDownTreasure = SKAction.moveTo(y: -obstacle.size.height * 0.5, duration: 3.0)
            let sequenceTreasure = SKAction.sequence([moveDownTreasure, remove])
            
            treasure.run(sequenceTreasure)
        }
        
        obstacle.run(sequence)
        toilet.run(sequenceToilet)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //backgroundSwitch()
        
        player.physicsBody?.affectedByGravity=true
        
        guard let touch = touches.first else { return }
        let touchIdentifier = touch.hashValue
        
        
        
        if(canJump==true){
            
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 500))
            player.physicsBody?.affectedByGravity=true
            previousJump = lastJump
            lastJump=touchIdentifier
            canJump=false
            
            self.playSound(sound: ArcadeGameScene.jumpSound)
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let previousTouchLocation = touch.previousLocation(in: self)
        
        
        // Calculate the horizontal movement based on the change in touch location
        let horizontalMovement = touchLocation.x - previousTouchLocation.x
        if(canJump==false){
            if horizontalMovement > 0{
                // Adjust the player's position based on the horizontal movement
                player.position.x += horizontalMovement
                // player.physicsBody?.applyForce(CGVector(dx: 100, dy: 0))
            }
            else
            {player.position.x += horizontalMovement
                //    player.physicsBody?.applyForce(CGVector(dx: -100, dy: 0))}
            }}}
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(player.physicsBody?.affectedByGravity==true){
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -400))}
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print(QuoteOn)
        var first = contact.bodyA
        var second = contact.bodyB
        
        /*it should be obstacle size.x/2 instead of 25*/
        
        //Checking if contact with a platform, not with a gem
        if(first.categoryBitMask != 1 && first.categoryBitMask != 4){
            if((contact.contactPoint.x>player.position.x-25 || contact.contactPoint.x<player.position.x+25) && contact.contactPoint.y<player.position.y ){
                player.physicsBody?.affectedByGravity=false
                player.physicsBody?.velocity.dy=0
                
                movingWith = first.node as! SKSpriteNode
                
            }}
            else if(second.categoryBitMask != 1 && second.categoryBitMask != 4){
                if((contact.contactPoint.x>player.position.x-25 || contact.contactPoint.x<player.position.x+25) && contact.contactPoint.y<player.position.y){
                    player.physicsBody?.affectedByGravity=false
                    player.physicsBody?.velocity.dy=0
                    
                    movingWith = second.node as! SKSpriteNode
                }}

        //contact with a platform
        if (first.categoryBitMask==1 && second.categoryBitMask==3){
            canJump=true
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            //player.position.y = second.node!.position.y + player.size.height+400
           
        }else if (first.categoryBitMask==3 && second.categoryBitMask==1){

            canJump=true
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            //player.position.y = first.node!.position.y + player.size.height+400

        }
     
        
        //Contact with a toilet
        if first.collisionBitMask == 1 && second.collisionBitMask == 2{
            if (second.node?.position.y)!+25<player.position.y{
                if let toilet = childNode(withName: (second.node?.name)!) as? Toilet {
                    let numberString = String(toilet.name!.dropFirst(6))
   
                    if !toilet.contactOccurred {
                        //toilet.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 40,height:  30))
                        toilet.changeTextureWithAnimation(newTexture: SKTexture(imageNamed: "closedToilet2"))
                        
                        self.playSound(sound: ArcadeGameScene.splashToiletsSound)
                        
                        if lastjumpScored[previousJump] == Int(numberString)!-1{
                            self.gameLogic.combo(points: 1)
                            self.animateComboPoints()
                        }
                        else{
                            player.run(SKAction.setTexture(SKTexture(imageNamed: "character")))

                            self.gameLogic.resetCombo()
                        }
                        lastScored = Int(numberString)!
                        scorePoints()
                        lastjumpScored[lastJump] = lastScored
                        toilet.contactOccurred = true
                    }
                    else if lastjumpScored[previousJump] != Int(numberString)!-1 && lastjumpScored[previousJump] != Int(numberString)! {
                        player.run(SKAction.setTexture(SKTexture(imageNamed: "character")))
                        self.gameLogic.resetCombo()
                    }
                }
            }
        }
        else if second.collisionBitMask == 1 && first.collisionBitMask == 2{
            if (first.node?.position.y)!+25<player.position.y{
                if let toilet = childNode(withName: (first.node?.name)!) as? Toilet {
                    let numberString = String(toilet.name!.dropFirst(6))
                    // The assignment is possible, do something with the toilet
                    // For example, increment the score
                    if toilet.contactOccurred == false{
                        //toilet.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 40,height:  30))
                        toilet.changeTextureWithAnimation(newTexture: SKTexture(imageNamed: "closedToilet2"))
                        if lastjumpScored[previousJump] == Int(numberString)!-1{
                            self.gameLogic.combo(points: 1)
                            self.animateComboPoints()
                        }
                        else{
                            self.gameLogic.resetCombo()
                            player.run(SKAction.setTexture(SKTexture(imageNamed: "character")))

                        }
                        lastScored = Int(numberString)!
                        scorePoints()
                        lastjumpScored[lastJump] = lastScored
                        toilet.contactOccurred = true
                    }
                    else if lastjumpScored[previousJump] != Int(numberString)!-1 && lastjumpScored[previousJump] != Int(numberString)!{
                        self.gameLogic.resetCombo()
                        player.run(SKAction.setTexture(SKTexture(imageNamed: "character")))

                    }
                }
            }
        }
        
        //contact with a gem
        if second.collisionBitMask == 1 && first.collisionBitMask == 3 {
            self.gameLogic.score(points: 100)
            self.animateScorePoints()
            self.playSound(sound: ArcadeGameScene.earnedScoreSound)
            torpedoDidCollideWithAlien(torpedoNode: second.node as! SKSpriteNode, alienNode: first.node as! SKSpriteNode)
            first.node?.removeFromParent()
        }
        else if second.collisionBitMask == 3 && first.collisionBitMask == 1 {
            self.gameLogic.score(points: 100)
            self.animateScorePoints()
            self.playSound(sound: ArcadeGameScene.earnedScoreSound)
            torpedoDidCollideWithAlien(torpedoNode: first.node as! SKSpriteNode, alienNode: second.node as! SKSpriteNode)
            second.node?.removeFromParent()
        }
        
        if first.collisionBitMask == 1 && second.collisionBitMask == 4{
            if (second.node?.position.y)!+25<player.position.y{
                if(CastleExists){
                    onCloud = true
                }else{
                    onCloud = false
                }
            }
        }
        else if second.collisionBitMask == 1 && first.collisionBitMask == 4{
            if (first.node?.position.y)!+25<player.position.y{
                if(CastleExists){
                    onCloud = true
                }else{
                    onCloud = false
                }            }
        } else{            
            onCloud=false
            QuoteOn=false}
        
        
        
        
        
    }
    
    func torpedoDidCollideWithAlien(torpedoNode: SKSpriteNode, alienNode: SKSpriteNode){
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = alienNode.position
        self.addChild(explosion)
        self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        alienNode.removeFromParent()
        
        self.run(SKAction.wait(forDuration: 2)){
            explosion.removeFromParent()
        }
        self.gameLogic.score(points: 5)
        self.animateScorePoints()
        self.playSound(sound: ArcadeGameScene.earnedScoreSound)
    }
    
    
    func scorePoints() {
        let combo = self.gameLogic.currentCombo
        
        self.gameLogic.score(points: 5)
        self.animateScorePoints()
        self.playSound(sound: ArcadeGameScene.earnedScoreSound)
        
        if(combo>1){
            comboMultipl=2
            self.gameLogic.score(points: 5)
            self.animateScorePoints()
            self.playSound(sound: ArcadeGameScene.earnedScoreSound)
        }
        if(combo>4){
            comboMultipl=4
            self.gameLogic.score(points: 10)
            self.animateScorePoints()
            self.playSound(sound: ArcadeGameScene.earnedScoreSound)
        }
        if(combo>9){
            player.run(SKAction.setTexture(SKTexture(imageNamed: "satisfiedCharacter")))
            comboMultipl=10
            self.gameLogic.score(points: 30)
            self.animateScorePoints()
            self.playSound(sound: ArcadeGameScene.earnedScoreSound)
        }
        if(combo>19){
            comboMultipl=20
            self.gameLogic.score(points: 50)
            self.animateScorePoints()
            self.playSound(sound: ArcadeGameScene.earnedScoreSound)
        }
        if(combo>49)
        {
            comboMultipl=40
            self.gameLogic.score(points: 100)
            self.animateScorePoints()
            self.playSound(sound: ArcadeGameScene.earnedScoreSound)
        }
    }
    
    func setConstraints() {
        // Create constraints to keep the player within the screen frame
        let rangeX = SKRange(lowerLimit:25, upperLimit: size.width-25)
        let rangeY = SKRange(lowerLimit: 0, upperLimit: size.height)
        
        let constraintX = SKConstraint.positionX(rangeX)
        let constraintY = SKConstraint.positionY(rangeY)
        
        // Apply constraints to the player
        player.constraints = [constraintX, constraintY]
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
            print("darkmode")
            isDarkMode=true
        }
        else{
            print("light mode")
            isDarkMode=false
        }
        
        if onCloud == true && QuoteOn==false{
            princessQuotation()
        }


        if(player.physicsBody?.affectedByGravity==false){
           player.position.y=movingWith.position.y+40
        }
        
        
        if player.position.y<25, !self.gameLogic.isGameOver {
            self.playSound(sound: ArcadeGameScene.endGameSound)
            self.gameLogic.finishTheGame()
        }
        
        updateUI()
    }
    
    func updateUI() {
        self.scoreLabel.text = "Score: \(self.gameLogic.currentScore)"
        self.comboLabel.text = "Combo: x\(self.gameLogic.currentCombo)"
    }
    
    private func setUpGame() {
        
        if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
            print("darkmode")
            isDarkMode=true
        }
        else{
            print("light mode")
            isDarkMode=false
        }
        self.gameLogic.setUpGame()
        self.changeBackgroundColor(.white)
    }
    
    func changeBackgroundColor(_ color: SKColor) {
        self.backgroundColor = color
    }
    
    func animateScorePoints() {
        self.scoreLabel.removeAllActions()
        self.scoreLabel.run(bounceInOutAnimation)
    }
    
    func animateComboPoints() {
        self.comboLabel.removeAllActions()
        self.comboLabel.run(bounceInOutAnimation)
    }
}

extension ArcadeGameScene {
    static let startGameSound = SKAction.playSoundFileNamed("start-game-sound.wav", waitForCompletion: false)
    static let earnedScoreSound = SKAction.playSoundFileNamed("earned-score-sound.wav", waitForCompletion: false)
    static let jumpSound = SKAction.playSoundFileNamed("jump-sound.wav", waitForCompletion: false)
    static let endGameSound = SKAction.playSoundFileNamed("end-game-sound.wav", waitForCompletion: false)
    static let splashToiletsSound = SKAction.playSoundFileNamed("splash-toilets-sound.wav", waitForCompletion: false)

    func playSound(sound: SKAction) {
        run(sound)
    }
}
