//
//  ArcadeGameScene.swift
//  ArcadeGameTemplate
//

import SpriteKit
import SwiftUI

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
    
}

class Treasure: SKSpriteNode{
    
    init(texture: SKTexture, size: CGSize) {
           super.init(texture: texture, color: .clear, size: size)

       }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ArcadeGameScene: SKScene, SKPhysicsContactDelegate {

    var gameLogic: ArcadeGameLogic = ArcadeGameLogic.shared
    
    var obstaclesCreated = 0
    var canJump: Bool = true
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var comboLabel: SKLabelNode!
    var movingWith: SKNode!
    
    var lastScored : Int = 0
    var lastJump : Int = 0
    var previousJump : Int = 0
    var lastjumpScored : [Int: Int] = [:]
    var comboMultipl: Int = 0
    var score : Int = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    var combo : Int = 1 {
        didSet{
            comboLabel.text = "Combo: x\(combo)"
        }
    }
    
    
    func createBackground() {
        
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
        run(sequence)
        
    }
    
    
    
    
    override func didMove(to view: SKView) {
        self.view?.showsPhysics = true

        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -100)
        createBackground()
        createPlayer()
        createGround()
        spawnObstacles()
        setConstraints()
        
        
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 50, y: self.frame.size.height-30)
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 18
        scoreLabel.fontColor = UIColor.white
        score=0
        self.addChild(scoreLabel)
        
        comboLabel = SKLabelNode(text: "Combo: x0")
        comboLabel.position = CGPoint(x: self.frame.size.width-60, y: self.frame.size.height-30)
        comboLabel.fontName = "AmericanTypewriter-Bold"
        comboLabel.fontSize = 18
        comboLabel.fontColor = UIColor.white
        combo=0
        self.addChild(comboLabel)
        
        
    }
    
    
    func createPlayer() {
        player = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 50))
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
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
        let spawnRight = SKAction.run {
            self.createObstacleRight()
        }
        let spawnLeft = SKAction.run {
            self.createObstacleLeft()
        }
        let sequence = SKAction.sequence([wait, spawnRight, wait, spawnLeft])
        let repeatForever = SKAction.repeatForever(sequence)
        run(repeatForever)
    }
    
    
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
        
        
        
        let obstacle = Obstacle(texture: SKTexture(imageNamed: "Group 1"), size: CGSize(width: CGFloat(150), height: 50))
        obstacle.name = "obstacle" + String(obstaclesCreated)
        obstacle.position = CGPoint(x: size.width * 0.85, y: size.height)
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.categoryBitMask = 3
        obstacle.physicsBody?.contactTestBitMask = 1
        obstaclesCreated+=1
        
        let toilet = Toilet(texture: SKTexture(imageNamed: "opentoilet"), size: CGSize(width: CGFloat(40), height: 60))
        toilet.name = "toilet" + String(obstaclesCreated)
        toilet.position = CGPoint(x: CGFloat.random(in: obstacle.position.x-50...obstacle.position.x+50), y: obstacle.position.y+50)
        toilet.physicsBody = SKPhysicsBody(rectangleOf: toilet.size)
        toilet.physicsBody?.isDynamic = false
        toilet.physicsBody?.categoryBitMask = 3
        toilet.physicsBody?.contactTestBitMask = 1
        toilet.physicsBody?.collisionBitMask=2

        addChild(obstacle)
        addChild(toilet)
        
        let moveDownOb = SKAction.moveTo(y: -obstacle.size.height * 0.5, duration: 3.0)
        let moveDownToilet = SKAction.moveTo(y: -toilet.size.height * 0.5, duration: 3.17)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveDownOb, remove])
        let sequenceToilet = SKAction.sequence([moveDownToilet, remove])
        
        if (combo%5==0 && combo != 0) {let treasure = Treasure(texture: SKTexture(imageNamed: "tile_0067"), size: CGSize(width: 30, height: 30))
            treasure.position = CGPoint(x: CGFloat.random(in: obstacle.position.x-300...obstacle.position.x-150), y: obstacle.position.y)
            
            treasure.physicsBody = SKPhysicsBody(rectangleOf: treasure.size)
            treasure.physicsBody?.isDynamic = false
            treasure.physicsBody?.categoryBitMask = 4
            treasure.physicsBody?.contactTestBitMask = 1
            treasure.physicsBody?.collisionBitMask=3
            
            addChild(treasure)
            let moveDownTreasure = SKAction.moveTo(y: -obstacle.size.height * 0.5, duration: 3.0)
            let sequenceTreasure = SKAction.sequence([moveDownTreasure, remove])
               
            
            treasure.run(sequenceTreasure)}
        obstacle.run(sequence)
        toilet.run(sequenceToilet)

       
    }
    
    
    func createObstacleLeft() {
        
        let obstacle = Obstacle(texture: SKTexture(imageNamed: "Group 2"), size: CGSize(width: CGFloat(150), height: 50))
        obstacle.name = "obstacle" + String(obstaclesCreated)
        obstacle.position = CGPoint(x: size.width * 0.15, y: size.height)
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.categoryBitMask = 3
        obstacle.physicsBody?.contactTestBitMask = 1
        obstaclesCreated+=1


        let toilet = Toilet(texture: SKTexture(imageNamed: "opentoilet"), size: CGSize(width: CGFloat(40), height: 60))
        toilet.name = "toilet" + String(obstaclesCreated)

        toilet.position = CGPoint(x: CGFloat.random(in: obstacle.position.x-50...obstacle.position.x+50), y: obstacle.position.y+50)
        toilet.physicsBody = SKPhysicsBody(rectangleOf: toilet.size)
        toilet.physicsBody?.isDynamic = false
        toilet.physicsBody?.categoryBitMask = 3
        toilet.physicsBody?.contactTestBitMask = 1
        toilet.physicsBody?.collisionBitMask=2
        
        addChild(obstacle)
        addChild(toilet)

        
        
        let moveDownOb = SKAction.moveTo(y: -obstacle.size.height * 0.5, duration: 3.0)
        let moveDownToilet = SKAction.moveTo(y: -toilet.size.height * 0.5, duration: 3.17)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveDownOb, remove])
        let sequenceToilet = SKAction.sequence([moveDownToilet, remove])


        
        if (combo%5==0 && combo != 0){
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
            
            treasure.run(sequenceTreasure)}
        obstacle.run(sequence)
        toilet.run(sequenceToilet)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        player.physicsBody?.affectedByGravity=true
        
        guard let touch = touches.first else { return }
        let touchIdentifier = touch.hashValue
        
        
        
        if(canJump==true){
            
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 500))
            player.physicsBody?.affectedByGravity=true
            previousJump = lastJump
            lastJump=touchIdentifier
            canJump=false
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
        
        var first = contact.bodyA
        var second = contact.bodyB
        
        /*it should be obstacle size.x/2 instead of 25*/
        
        //Checking if contact with a platform, not with a gem
        if(first.categoryBitMask != 1 && first.categoryBitMask != 4){
            if(contact.contactPoint.x>player.position.x-25 || contact.contactPoint.x<player.position.x+25 ){
                player.physicsBody?.affectedByGravity=false
                player.physicsBody?.velocity.dy=0
                
                movingWith = first.node as! SKNode
                print(movingWith.name)
                
            }}
            else if(second.categoryBitMask != 1 && second.categoryBitMask != 4){
                if(contact.contactPoint.x>player.position.x-25 || contact.contactPoint.x<player.position.x+25 ){
                    player.physicsBody?.affectedByGravity=false
                    player.physicsBody?.velocity.dy=0
                    
                    movingWith = second.node as! SKNode
                    print(movingWith.name)
                }}

        //contact with a platform
        if (first.categoryBitMask==1 && second.categoryBitMask==3){
            canJump=true
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player.position.y = second.node!.position.y + player.size.height+400
           
        }else if (first.categoryBitMask==3 && second.categoryBitMask==1){

            canJump=true
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player.position.y = first.node!.position.y + player.size.height+400

        }
     
        
        //Contact with a toilet
        if first.collisionBitMask == 1 && second.collisionBitMask == 2{
            if (second.node?.position.y)!+25<player.position.y{
                if let toilet = childNode(withName: (second.node?.name)!) as? Toilet {
                    let numberString = String(toilet.name!.dropFirst(6))

                    if toilet.contactOccurred == false{
                        //toilet.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 40,height:  30))
                        toilet.texture=SKTexture(imageNamed: "closedtoilet")
                        print("\(toilet.name) scored")
                        print(Int(numberString)!)
                        if lastjumpScored[previousJump] == Int(numberString)!-1{
                            print("combo")
                            combo+=1
                        }
                        else{
                            print("combo broken")
                            combo=0
                        }
                        lastScored = Int(numberString)!
                        scorePoints()
                        lastjumpScored[lastJump] = lastScored
                        toilet.contactOccurred = true
                    }
                    else if lastjumpScored[previousJump] != Int(numberString)!-1 && lastjumpScored[previousJump] != Int(numberString)!  {
                        combo=0
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
                        toilet.texture=SKTexture(imageNamed: "closedtoilet")
                        print("\(toilet.name) scored")
                        print(Int(numberString)!)
                        if lastjumpScored[previousJump] == Int(numberString)!-1{
                            print("combo")
                            combo+=1
                        }
                        else{
                            print("combo broken")
                            combo=0
                        }
                        lastScored = Int(numberString)!
                        scorePoints()
                        lastjumpScored[lastJump] = lastScored
                        toilet.contactOccurred = true
                    }
                    else if lastjumpScored[previousJump] != Int(numberString)!-1 && lastjumpScored[previousJump] != Int(numberString)!{
                        combo=0
                    }
                }
            }
        }
        
        //contact with a gem
        if second.collisionBitMask == 1 && first.collisionBitMask == 3{
            score+=100
            torpedoDidCollideWithAlien(torpedoNode: second.node as! SKSpriteNode, alienNode: first.node as! SKSpriteNode)
            first.node?.removeFromParent()
        }
        else if second.collisionBitMask == 3 && first.collisionBitMask == 1{
            score+=100
            torpedoDidCollideWithAlien(torpedoNode: first.node as! SKSpriteNode, alienNode: second.node as! SKSpriteNode)
            second.node?.removeFromParent()
        }
        
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
        score+=5
    }
    
    
    func scorePoints(){
        score+=5
        if(combo>1){
            comboMultipl=2
            score += 5}
        if(combo>4){
            comboMultipl=4
            score += 10}
        if(combo>9){
            comboMultipl=10
            score += 30}
        if(combo>19){
            comboMultipl=20
            score += 50}
        if(combo>49)
        {
            comboMultipl=40
            score += 100}
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

        if(player.physicsBody?.affectedByGravity==false){
            player.position.y=movingWith.position.y+50
        }
        
        
        if player.position.y<25{
            gameLogic.isGameOver=true
            print("Gameover")
        }
    }
    
    
    private func setUpGame() {
        self.gameLogic.setUpGame()
        self.backgroundColor = SKColor.white
        
    }
    
}
