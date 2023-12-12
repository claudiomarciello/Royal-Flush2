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
    /**
     * # The Game Logic
     *     The game logic keeps track of the game variables
     *   you can use it to display information on the SwiftUI view,
     *   for example, and comunicate with the Game Scene.
     **/
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
        
        //createObstacle()
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
        obstaclesCreated+=1
        obstacle.position = CGPoint(x: size.width * 0.85, y: size.height)
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.categoryBitMask = 3
        obstacle.physicsBody?.contactTestBitMask = 1
        //obstacle.physicsBody?.mass=200
        
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
        
        if (combo+1)%6==0 {let treasure = Treasure(texture: SKTexture(imageNamed: "tile_0067"), size: CGSize(width: 30, height: 30))
            treasure.position = CGPoint(x: CGFloat.random(in: obstacle.position.x-300...obstacle.position.x-150), y: obstacle.position.y)
            
            treasure.physicsBody = SKPhysicsBody(rectangleOf: treasure.size)
            treasure.physicsBody?.isDynamic = false
            treasure.physicsBody?.categoryBitMask = 4
            treasure.physicsBody?.contactTestBitMask = 1
            treasure.physicsBody?.collisionBitMask=3
            
            addChild(treasure)
            print("treasure created")
            let moveDownTreasure = SKAction.moveTo(y: -obstacle.size.height * 0.5, duration: 3.0)
            let sequenceTreasure = SKAction.sequence([moveDownTreasure, remove])
               treasure.run(sequenceTreasure)}

    
        obstacle.run(sequence)
        toilet.run(sequenceToilet)

       
    }
    
    
    func createObstacleLeft() {
        
        let obstacle = Obstacle(texture: SKTexture(imageNamed: "Group 2"), size: CGSize(width: CGFloat(150), height: 50))
        obstacle.name = "obstacle" + String(obstaclesCreated)
        obstaclesCreated+=1
        obstacle.position = CGPoint(x: size.width * 0.15, y: size.height)
        
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.categoryBitMask = 3
        obstacle.physicsBody?.contactTestBitMask = 1
        obstacle.physicsBody?.mass=200

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


        
        if (combo+1)%6==0{
            let treasure = Treasure(texture: SKTexture(imageNamed: "tile_0067"), size: CGSize(width: 30, height: 30))
            treasure.position = CGPoint(x: CGFloat.random(in: obstacle.position.x+150...obstacle.position.x+300), y: obstacle.position.y)
            
            treasure.physicsBody = SKPhysicsBody(rectangleOf: treasure.size)
            treasure.physicsBody?.isDynamic = false
            treasure.physicsBody?.categoryBitMask = 4
            treasure.physicsBody?.contactTestBitMask = 1
            treasure.physicsBody?.collisionBitMask=3
            
            addChild(treasure)
            print("treasure created")
            
            let moveDownTreasure = SKAction.moveTo(y: -obstacle.size.height * 0.5, duration: 3.0)
            let sequenceTreasure = SKAction.sequence([moveDownTreasure, remove])
            
            treasure.run(sequenceTreasure)}
        
  
        
        
        obstacle.run(sequence)
        toilet.run(sequenceToilet)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        player.physicsBody?.affectedByGravity=true
        
        //canJump=false
        guard let touch = touches.first else { return }
        
        
        // let touchLocation = touch.location(in: self)
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
        
        if(contact.contactPoint.x>player.position.x-25 || contact.contactPoint.x<player.position.x+25 ){
            if(contact.bodyA.categoryBitMask != 4 && contact.bodyB.categoryBitMask != 4){
                player.physicsBody?.affectedByGravity=false
                player.physicsBody?.velocity.dy=0
                
                if(contact.bodyA.node==player){
                    movingWith = contact.bodyB.node as! SKNode
                    print(movingWith.name)}
                else{
                    movingWith = contact.bodyA.node as! SKNode
                    print(movingWith.name)}}}

        
        if (contact.bodyA.categoryBitMask==1 && contact.bodyB.categoryBitMask==3){
            print(contact.bodyB.velocity.dy)
            canJump=true
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player.position.y = contact.bodyB.node!.position.y + player.size.height+400
           
        }else if (contact.bodyA.categoryBitMask==3 && contact.bodyB.categoryBitMask==1){
            print(contact.bodyB.velocity.dy)

            /*let fixedJoint = SKPhysicsJointFixed.joint(withBodyA: contact.bodyA.node!.physicsBody!,
             bodyB: contact.bodyB.node!.physicsBody!,
             anchor: CGPoint(x: contact.bodyA.node!.position.x, y: contact.bodyA.node!.position.y + 50))
             physicsWorld.add(fixedJoint)*/
            print("canjump=true")
            
            canJump=true
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player.position.y = contact.bodyA.node!.position.y + player.size.height+400
           
            
        }
        
        
        
        
        
        
        if contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 2 {
            //print("canjump=true")
            
            canJump=true
            player.physicsBody?.affectedByGravity=false
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player.position.y = contact.bodyB.node!.position.y + player.size.height+400
            
        }
        else if contact.bodyB.categoryBitMask == 1 && contact.bodyA.categoryBitMask == 2
        {
            //print("canjump=true")
            canJump=true
            player.physicsBody?.affectedByGravity=false
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player.position.y = contact.bodyA.node!.position.y + player.size.height+400
        }
        
        if contact.bodyA.collisionBitMask == 1 && contact.bodyB.collisionBitMask == 2{
            
            if (contact.bodyB.node?.position.y)!+25<player.position.y{
                
                if let toilet = childNode(withName: (contact.bodyB.node?.name)!) as? Toilet {
                    let numberString = String(toilet.name!.dropFirst(6))
                    print("\(player.position.x) - contact: \(contact.contactPoint.x) ")

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
                        toilet.contactOccurred = true}
                    else if lastjumpScored[previousJump] != Int(numberString)!-1 && lastjumpScored[previousJump] != Int(numberString)!  {
                        combo=0
                    }
                }
            }
            
            
        }
        else if contact.bodyB.collisionBitMask == 1 && contact.bodyA.collisionBitMask == 2{
            if (contact.bodyA.node?.position.y)!+25<player.position.y{
                if let toilet = childNode(withName: (contact.bodyA.node?.name)!) as? Toilet {
                    print("\(player.position.x) - contact: \(contact.contactPoint.x) ")
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
                        toilet.contactOccurred = true}
                    else if lastjumpScored[previousJump] != Int(numberString)!-1 && lastjumpScored[previousJump] != Int(numberString)!{
                        combo=0
                    }
                }
            }
        }
        
        if contact.bodyB.collisionBitMask == 1 && contact.bodyA.collisionBitMask == 3{
            score+=100
            torpedoDidCollideWithAlien(torpedoNode: contact.bodyB.node as! SKSpriteNode, alienNode: contact.bodyA.node as! SKSpriteNode)
            contact.bodyA.node?.removeFromParent()
        }
        else if contact.bodyB.collisionBitMask == 3 && contact.bodyA.collisionBitMask == 1{
            score+=100
            torpedoDidCollideWithAlien(torpedoNode: contact.bodyA.node as! SKSpriteNode, alienNode: contact.bodyB.node as! SKSpriteNode)
            contact.bodyB.node?.removeFromParent()
        }
        
        
        
        
        
        
        
        
        
        
    }
    
    func torpedoDidCollideWithAlien(torpedoNode: SKSpriteNode, alienNode: SKSpriteNode){
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = alienNode.position
        self.addChild(explosion)
        self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        //torpedoNode.removeFromParent()
        alienNode.removeFromParent()
        
        self.run(SKAction.wait(forDuration: 2)){
            explosion.removeFromParent()
        }
        score+=5
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
        
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
        
       /* let playerInitialPosition = CGPoint(x: self.frame.width/2, y: self.frame.height/6)
        self.createPlayer(at: playerInitialPosition)
        
        self.startAsteroidsCycle()*/
    }
    
}
    
    /*
    
    
    
    
    
    
    
    
    
    // Keeps track of when the last update happend.
    // Used to calculate how much time has passed between updates.
    var lastUpdate: TimeInterval = 0
    
    var player: SKShapeNode!
    
    var isMovingToTheRight: Bool = false
    var isMovingToTheLeft: Bool = false
    
    override func didMove(to view: SKView) {
        self.setUpGame()
        self.setUpPhysicsWorld()
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        // ...
        
        // If the game over condition is met, the game will finish
        if self.isGameOver { self.finishGame() }
        
        // The first time the update function is called we must initialize the
        // lastUpdate variable
        if self.lastUpdate == 0 { self.lastUpdate = currentTime }
        
        // Calculates how much time has passed since the last update
        let timeElapsedSinceLastUpdate = currentTime - self.lastUpdate
        // Increments the length of the game session at the game logic
        self.gameLogic.increaseSessionTime(by: timeElapsedSinceLastUpdate)
        
        self.lastUpdate = currentTime
    }
    
}

// MARK: - Game Scene Set Up
extension ArcadeGameScene {
    
    private func setUpGame() {
        self.gameLogic.setUpGame()
        self.backgroundColor = SKColor.white
        
        let playerInitialPosition = CGPoint(x: self.frame.width/2, y: self.frame.height/6)
        self.createPlayer(at: playerInitialPosition)
        
        self.startAsteroidsCycle()
    }
    
    private func setUpPhysicsWorld() {
        // TODO: Customize!
    }
    
    private func restartGame() {
        self.gameLogic.restartGame()
    }
    
    private func createPlayer(at position: CGPoint) {
        self.player = SKShapeNode(circleOfRadius: 25.0)
        self.player.name = "player"
        self.player.fillColor = SKColor.blue
        self.player.strokeColor = SKColor.black
        
        self.player.position = position
        
        addChild(self.player)
    }
    
    func startAsteroidsCycle() {
        let createAsteroidAction = SKAction.run(createAsteroid)
        let waitAction = SKAction.wait(forDuration: 5.0)
        
        let createAndWaitAction = SKAction.sequence([createAsteroidAction, waitAction])
        let asteroidCycleAction = SKAction.repeatForever(createAndWaitAction)
        
        run(asteroidCycleAction)
    }
}

// MARK: - Player Movement
extension ArcadeGameScene {
    
}

// MARK: - Handle Player Inputs
extension ArcadeGameScene {
    
    enum SideOfTheScreen {
        case right, left
    }
    
    private func sideTouched(for position: CGPoint) -> SideOfTheScreen {
        if position.x < self.frame.width / 2 {
            return .left
        } else {
            return .right
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        switch sideTouched(for: touchLocation) {
        case .right:
            self.isMovingToTheRight = true
            print("ℹ️ Touching the RIGHT side.")
        case .left:
            self.isMovingToTheLeft = true
            print("ℹ️ Touching the LEFT side.")
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isMovingToTheRight = false
        self.isMovingToTheLeft = false
    }
    
}


// MARK: - Game Over Condition
extension ArcadeGameScene {
    
    /**
     * Implement the Game Over condition.
     * Remember that an arcade game always ends! How will the player eventually lose?
     *
     * Some examples of game over conditions are:
     * - The time is over!
     * - The player health is depleated!
     * - The enemies have completed their goal!
     * - The screen is full!
     **/
    
    var isGameOver: Bool {
        // TODO: Customize!
        
        // Did you reach the time limit?
        // Are the health points depleted?
        // Did an enemy cross a position it should not have crossed?
        
        return gameLogic.isGameOver
    }
    
    private func finishGame() {
        
        // TODO: Customize!
        
        gameLogic.isGameOver = true
    }
    
}

// MARK: - Register Score
extension ArcadeGameScene {
    
    private func registerScore() {
        // TODO: Customize!
    }
    
}

// MARK: - Asteroids
extension ArcadeGameScene {
    
    private func createAsteroid() {
        let asteroidPosition = self.randomAsteroidPosition()
        newAsteroid(at: asteroidPosition)
    }
    
    private func randomAsteroidPosition() -> CGPoint {
        let initialX: CGFloat = 25
        let finalX: CGFloat = self.frame.width - 25
        
        let positionX = CGFloat.random(in: initialX...finalX)
        let positionY = frame.height - 25
        
        return CGPoint(x: positionX, y: positionY)
    }
    
    private func newAsteroid(at position: CGPoint) {
        let newAsteroid = SKShapeNode(circleOfRadius: 25)
        newAsteroid.name = "asteroid"
        newAsteroid.fillColor = SKColor.red
        newAsteroid.strokeColor = SKColor.black
        
        newAsteroid.position = position
        
        addChild(newAsteroid)
        
        newAsteroid.run(SKAction.sequence([
            SKAction.wait(forDuration: 5.0),
            SKAction.removeFromParent()
        ]))
    }
    
}
*/
