//
//  GameScene.swift
//  verticalJump
//
//  Created by Claudio Marciello on 07/12/23.
//
import SpriteKit



class Obstacle: SKSpriteNode {
    var contactOccurred: Bool = false // Example property, you can customize this based on your needs
    //var inContact = Bool = false
    init(texture: SKTexture, size: CGSize) {
           super.init(texture: texture, color: .clear, size: size)

           // Additional setup for the obstacle's physics body, categoryBitMask, etc.
           self.physicsBody = SKPhysicsBody(rectangleOf: size)
           self.physicsBody?.isDynamic = false
           self.physicsBody?.categoryBitMask = 3
           self.physicsBody?.contactTestBitMask = 1
       }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class GameScene: SKScene, SKPhysicsContactDelegate {

    var obstaclesCreated = 0
    var canJump: Bool = true
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!

    var score : Int = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    
        
    func createBackground() {
        var width = size.width
        var height = size.height
        // Create a blue sky
        let skyColor = SKColor(red: 135.0/255.0, green: 206.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        self.backgroundColor = skyColor
        
        // Create and add clouds to the scene
        let cloudTexture = SKTexture(imageNamed: "pixel_cloud") // Replace "cloud.png" with your cloud image name
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

        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -100)
        createBackground()
        createPlayer()
        createGround()
        spawnObstacles()
        //createObstacle()
        setConstraints()
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height-100)
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = UIColor.black
        score=0
        self.addChild(scoreLabel)
        

    }
    
    
    func createPlayer() {
        player = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 50))
        player.position = CGPoint(x: size.width * 0.2, y: size.height * 0.5)
        player.name = "player"

        
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.categoryBitMask = 1
        player.physicsBody?.collisionBitMask = 1
        player.physicsBody?.contactTestBitMask = 1
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
        let ground = SKSpriteNode(color: .green, size: CGSize(width: size.width+100, height: 50))
        ground.position = CGPoint(x: size.width * 0.5, y: size.height * 0.01)
        ground.name = "ground"
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = 2
        ground.physicsBody?.contactTestBitMask = 1
        
        addChild(ground)
    }
    
    func createObstacleRight() {
        
        
        let obstacle = Obstacle(texture: SKTexture(imageNamed: "Group 1"), size: CGSize(width: CGFloat(150), height: 50))
        obstacle.name = "obstacle" + String(obstaclesCreated)
        obstaclesCreated+=1
        obstacle.position = CGPoint(x: size.width * 0.9, y: size.height)
        
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.categoryBitMask = 3
        obstacle.physicsBody?.contactTestBitMask = 1
        
        addChild(obstacle)
        
        
        let moveDown = SKAction.moveTo(y: -obstacle.size.height * 0.5, duration: 3.0)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveDown, remove])
        obstacle.run(sequence)
    }
    
    
    func createObstacleLeft() {
        let obstacle = Obstacle(texture: SKTexture(imageNamed: "Group 2"), size: CGSize(width: CGFloat(150), height: 50))
        obstacle.name = "obstacle" + String(obstaclesCreated)
        obstaclesCreated+=1
        obstacle.position = CGPoint(x: size.width * 0.1, y: size.height)
        
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.categoryBitMask = 3
        obstacle.physicsBody?.contactTestBitMask = 1
        
        
        addChild(obstacle)
        let moveDown = SKAction.moveTo(y: -obstacle.size.height * 0.5, duration: 3.0)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveDown, remove])
        obstacle.run(sequence)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
            player.physicsBody?.affectedByGravity=true

            //canJump=false
            guard let touch = touches.first else { return }
            
            
            let touchLocation = touch.location(in: self)
            

        if(canJump==true){
                
                player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 450))
            player.physicsBody?.affectedByGravity=true

                canJump=false
            }
        }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
           guard let touch = touches.first else { return }
           let touchLocation = touch.location(in: self)
           let previousTouchLocation = touch.previousLocation(in: self)
           
           //print("Continuous Input at \(touchLocation)")
           
           // Calculate the horizontal movement based on the change in touch location
           let horizontalMovement = touchLocation.x - previousTouchLocation.x
           
        if horizontalMovement > 0{
            // Adjust the player's position based on the horizontal movement
            player.position.x += horizontalMovement
            player.physicsBody?.applyForce(CGVector(dx: 100, dy: 0))
        }
        else
        {player.position.x += horizontalMovement
            player.physicsBody?.applyForce(CGVector(dx: -100, dy: 0))}
       }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(player.physicsBody?.affectedByGravity==true){
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -300))}
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //print("Game Over!")
        
        if (contact.bodyA.categoryBitMask==1 && contact.bodyB.categoryBitMask==3){
            //print("canjump=true")
            
            canJump=true
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player.position.y = contact.bodyB.node!.position.y + player.size.height+400
            if contact.contactPoint.y < player.position.y-player.size.height/2{
                if let obstacle = childNode(withName: (contact.bodyB.node?.name)!) as? Obstacle {
                    if(obstacle.contactOccurred==false){
                        if(obstacle.position.y < contact.contactPoint.y){
                            score+=5
                            print(score)
                            obstacle.contactOccurred=true}
                        
                        print("contacct point: \(contact.contactPoint.y) - player: \(player.position.y-player.size.height/2) - obstacle: \(obstacle.position.y)")}
                }}
            }
            else if (contact.bodyA.categoryBitMask==3 && contact.bodyB.categoryBitMask==1){
                print("canjump=true")
                
                canJump=true
                player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                player.position.y = contact.bodyA.node!.position.y + player.size.height+400
                if contact.contactPoint.y < player.position.y-player.size.height/2{
                    if let obstacle = childNode(withName: (contact.bodyA.node?.name)!) as? Obstacle {
                        if(obstacle.contactOccurred==false){
                            score+=5
                            print(score)
                            obstacle.contactOccurred=true
                            print("contacct point: \(contact.contactPoint.y) - player: \(player.position.y-player.size.height/2) - obstacle: \(obstacle.position.y)" )}
                        
                    }}
                
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
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {

    
    }
    
    func setConstraints() {
            // Create constraints to keep the player within the screen frame
            let rangeX = SKRange(lowerLimit: 0, upperLimit: size.width)
            let rangeY = SKRange(lowerLimit: 60, upperLimit: size.height)
            
            let constraintX = SKConstraint.positionX(rangeX)
            let constraintY = SKConstraint.positionY(rangeY)
            
            // Apply constraints to the player
            player.constraints = [constraintX, constraintY]
        }
        
}
