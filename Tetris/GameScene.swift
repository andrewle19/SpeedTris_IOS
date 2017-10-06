//
//  GameScene.swift
//  Tetris
//  Intializes the background
//  Created by andrew le on 9/30/16.
//  Copyright (c) 2016 ZDreams. All rights reserved.
// Controls the visuals of the game

import SpriteKit

// Define the size of each block sprite 20.0 X 20.0
var BlockSize:CGFloat = 20.0

//defining a constant this represents the slowest speed the pieces drop 6/10ths of a second
let TickLengthLevelOne = TimeInterval(550)

class GameScene: SKScene {
    
    // model of current device
    let model = UIDevice.current.model
    // Layer Position is an offset from the edge of the screen
    let gameLayer = SKNode()
    let shapeLayer = SKNode()
    
    // labels for score and level
    let scoreLabel = SKLabelNode(fontNamed: "Helvetica")
    let levelLabel = SKLabelNode(fontNamed: "Helvetica")
    let highScoreLabel = SKLabelNode(fontNamed: "Helvetica")

    let LayerPosition = CGPoint(x: 6, y: -6)
    
    //current tick length set to default tick length, lastTick keeps track the last time we experienced a tick,
    // tick indicates it returns nothing and has no parameters but ? can take paramets
    var tick:(()->())?
    
    var tickLengthMillis = TickLengthLevelOne
    
    var lastTick:Date?
    
    var textureCache = Dictionary<String,SKTexture>()
    
    var scaleFactor : CGFloat = 0 // scale the labels by this much
    
    required init(coder aDecoder: NSCoder)
    {
        fatalError("NSCoder not supported")
    }
    
    // initalizae the game scene
    override init(size: CGSize)
    {
        super.init(size: size) // super comes from super class. init is to intialize without parameters

        print(size)
        
        // checks model to determine block size and scale factor
        if(model == "iPad")
        {
            BlockSize = 40.0
            scaleFactor = 2
        }
        else
        {
            BlockSize = 20.0
            scaleFactor = 1
        }
        
        
        print("Scene Init")
        self.backgroundColor = UIColor(red: 0.31, green: 0.31, blue: 0.31, alpha: 1)
        self.anchorPoint = CGPoint(x: 0, y: 1.0) // set the anchor point 0:1 is the top left corner
        
    
        addChild(gameLayer) // adds the game layer
        
        let gameBoardTexture = SKTexture(imageNamed: "gameboard.png")
        let gameBoard = SKSpriteNode(texture: gameBoardTexture, size: CGSize(width: BlockSize * CGFloat(ColumnNum), height: BlockSize * CGFloat(RowNum)))
        
        gameBoard.anchorPoint = CGPoint(x:0, y:1.0)
        gameBoard.position = LayerPosition
    
        
        shapeLayer.position = LayerPosition
        shapeLayer.addChild(gameBoard) // add the gameBoard layer
        gameLayer.addChild(shapeLayer) // add the shape layer over the gameBoard layer
        
        
         // add the text label for Score
        let scoreTextLabel = SKLabelNode(fontNamed: "Helvetica")
        scoreTextLabel.text = "SCORE"
        scoreTextLabel.fontColor = UIColor(red: 0, green: 0.73, blue: 1, alpha: 1)
        scoreTextLabel.fontSize = 30
        scoreTextLabel.fontSize *= scaleFactor
        // position the text label
        scoreTextLabel.position = pointForColumn(column: 13, row: 7)
        gameLayer.addChild(scoreTextLabel)
        
        // setting the score label
        scoreLabel.text = "0"
        scoreLabel.fontColor = UIColor(red: 0, green: 0.84, blue: 0, alpha: 1)
        scoreLabel.fontSize = 35
        scoreLabel.fontSize *= scaleFactor
        scoreLabel.position = pointForColumn(column: 13, row: 9)
        gameLayer.addChild(scoreLabel)
        
        // add the text label for LEVEL
        let levelTextLabel = SKLabelNode(fontNamed: "Helvetica")
        levelTextLabel.text = "LEVEL"
        levelTextLabel.fontColor = UIColor(red: 0, green: 0.73, blue: 1, alpha: 1)
        levelTextLabel.fontSize = 31
        levelTextLabel.fontSize *= scaleFactor
        // positions the label
        levelTextLabel.position = pointForColumn(column: 13, row: 13)
        gameLayer.addChild(levelTextLabel)
        
        // setting the level label
        levelLabel.text = "1"
        levelLabel.fontColor = UIColor(red: 1, green: 0, blue: 0.05, alpha: 1)
        levelLabel.fontSize = 35
        levelLabel.fontSize *= scaleFactor
        levelLabel.position = pointForColumn(column: 13, row: 15)
        gameLayer.addChild(levelLabel)
        
        // add the  label for HIGHSCORE
        let highScoreTextLabel = SKLabelNode(fontNamed: "Helvetica")
        highScoreTextLabel.text = "HIGHSCORE"
        highScoreTextLabel.fontColor = UIColor(red: 0, green: 0.73, blue: 1, alpha: 1)
        highScoreTextLabel.fontSize = 27
        highScoreTextLabel.fontSize *= scaleFactor
        // positions the label
        highScoreTextLabel.position = pointForColumn(column: 14, row: 17)
        gameLayer.addChild(highScoreTextLabel)
        
        // setting the highscore label
        highScoreLabel.text = "0"
        highScoreLabel.fontColor = UIColor(red: 1, green: 0, blue: 0.05, alpha: 1)
        highScoreLabel.fontSize = 35
        highScoreLabel.fontSize *= scaleFactor
        highScoreLabel.position = pointForColumn(column: 13, row: 19)
        gameLayer.addChild(highScoreLabel)
        
        
        // Background sound plays forever
        run(SKAction.repeatForever(SKAction.playSoundFileNamed("Sounds/Background.mp3", waitForCompletion: true)))
        
        
        
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        /* Called before each frame is rendered */
        
        // guard like an if, if the last tick is missing the game is in a paused state
        
        guard let lastTick = lastTick else
        {
            return
        }
        // calculate a positive value for milisecond value
        let timePassed = lastTick.timeIntervalSinceNow * -1000.0

        // if enough time has elasped when time passed exceed our ticklengthMillis we report a tick
        if timePassed > tickLengthMillis
        {
            self.lastTick = Date()
            // check to see if tick exists and allows us to invoke it at no parameters
            tick?()
        }
    }
    
    // plays sound of string specefied
    
    func playSound(sound:String)
    {
        run(SKAction.playSoundFileNamed(sound, waitForCompletion: false))
    }
    
    // removes the tap to play game message
    func removePlayMsg()
    {
        scene?.childNode(withName: "Play")?.removeFromParent()
    }
    
    // Display a message to user telling them to tap to play game
    func displayPlayMsg()
    {
        let Play = SKLabelNode(fontNamed: "Helvetica")
        Play.name = "Play"
        Play.text = "Tap to Play!"
        Play.fontColor = UIColor.white
        Play.fontSize = 50
        
       ScaleFontToFit(labelNode: Play, rect: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        Play.position = CGPoint(x: frame.midX, y: frame.midY+10)
        
        self.addChild(Play)
    }
    
    // adjusts the font size to screen
    func ScaleFontToFit(labelNode:SKLabelNode, rect:CGRect) {
        
        // Determine the font scaling factor that should let the label text fit in the given rectangle.
        let scalingFactor = min(rect.width / labelNode.frame.width, rect.height / labelNode.frame.height)
        
        // Change the fontSize.
        labelNode.fontSize *= scalingFactor
        
    }
    
    //provide accessor methods that let external classes to stop and start
    func startTicking()
    {
        lastTick = Date()
    }
    
    func stopTicking()
    {
        lastTick = nil
    }
    
    // places the block sprite based on the column and row postion
    func pointForColumn(column: Int, row: Int) -> CGPoint
    {
        let x = LayerPosition.x + (CGFloat(column) * BlockSize) + (BlockSize / 2)
        let y = LayerPosition.y - ((CGFloat(row) * BlockSize) + (BlockSize / 2))
        return CGPoint(x: x, y: y)

    }
    
    // add the preview shape onto the scene
    func addPreviewShapeToScene(shape:Shape,completion:@escaping ()->())
    {
        for block in shape.blocks
        {
            // Add blocks to the dictionary Texture Cache
            var texture = textureCache[block.spriteName]
            
            if texture == nil
            {
                texture = SKTexture(imageNamed: block.spriteName)
                textureCache[block.spriteName] = texture
            }
            
            let sprite = SKSpriteNode(texture: texture)
            
            
            // Place each block sprite in proper location off screen
            sprite.position = pointForColumn(column: block.column, row: block.row-2)
            
            shapeLayer.addChild(sprite)
            
            block.sprite = sprite
            
            // Animation
            sprite.alpha = 0
            
            // SKAaction allows the sprites to animate fading them in when a new piece aprears
            // Redraws each block for a given shape
            let moveAction = SKAction.move(to: pointForColumn(column: block.column, row: block.row), duration: TimeInterval(0.2))
            
            moveAction.timingMode = .easeOut
            
            let fadeInAction = SKAction.fadeAlpha(to: 0.7, duration: 0.2)
            
            fadeInAction.timingMode = .easeOut
            
            sprite.run(SKAction.group([moveAction,fadeInAction]))
            
        }
        run(SKAction.wait(forDuration: 0.2),completion:completion)
    }
    
    // moving the preview shape onto the game board
    func movePreviewShape(shape:Shape,completion:@escaping () -> ())
    {
        
        print(shape)
        for block in shape.blocks
        {
            let sprite = block.sprite!
            
            let moveTo = pointForColumn(column: block.column, row: block.row)
            let moveToAction: SKAction = SKAction.move(to: moveTo, duration: 0.2)
            
            moveToAction.timingMode = .easeOut
            let fadeInAction = SKAction.fadeAlpha(to: 1.0, duration: 0.2)
            fadeInAction.timingMode = .easeOut
            sprite.run(SKAction.group([moveToAction, fadeInAction]))
            
        }
        run(SKAction.wait(forDuration: 0.2),completion:completion)
    }
    
    // redraws shape when shapes are destroyed
    func redrawShape(shape:Shape, completion:@escaping () -> ())
    {
        for block in shape.blocks
        {
            let sprite = block.sprite!
            
            let moveTo = pointForColumn(column: block.column, row: block.row)
            
            let moveToAction:SKAction = SKAction.move(to: moveTo, duration: 0.05)
            
            moveToAction.timingMode = .easeOut
            
            if block == shape.blocks.last
            {
                sprite.run(moveToAction, completion: completion)
            }
            else
            {
                sprite.run(moveToAction)
            }
        }
    }
    
    // Take in tuple date which returns each time it removes a line
    // ensure gameViewController will pass those items to game scene to animate
    func animateCollapsingLines(linesToRemove: Array<Array<Block>>,fallenBlocks: Array<Array<Block>>, completion: @escaping ()->())
    {
        // how long we wait before calling closure
        var longestDuration: TimeInterval = 0
        
        //cascade them left to right when fallen
        for(columnIdx,column) in fallenBlocks.enumerated()
        {
            for(blockIdx,block) in column.enumerated()
            {
                let newPosition = pointForColumn(column: block.column, row: block.row)
                let sprite = block.sprite!
                
                // blocks will fall one after another
                let delay = (TimeInterval(columnIdx) * 0.05) + (TimeInterval(blockIdx)*0.05)
                
                let duration = TimeInterval(((sprite.position.y - newPosition.y) / BlockSize) * 0.1)
                let moveAction = SKAction.move(to: newPosition, duration: duration)
                
                moveAction.timingMode = .easeOut
                
                sprite.run(SKAction.sequence([SKAction.wait(forDuration: delay),moveAction]))
                longestDuration = max(longestDuration,duration+delay)
            }
        }
        
        for rowToRemove in linesToRemove
        {
            // Blocks shoot of screen explosively
            for block in rowToRemove
            {
                let randomRadius = CGFloat(UInt(arc4random_uniform(400)+100))
                let goLeft = arc4random_uniform(100) % 2 == 0
                
                var point = pointForColumn(column: block.column, row: block.row)
                point = CGPoint(x: point.x + (goLeft ? -randomRadius : randomRadius), y: point.y)
                
                let randomDuration = TimeInterval(arc4random_uniform(2))+0.5
                
                // Choose the starting angle
                var startAngle = CGFloat(M_PI)
                var endAngle = startAngle * 2
                
                if goLeft
                {
                    endAngle = startAngle
                    startAngle = 0
                }
                
                let archPath = UIBezierPath(arcCenter: point, radius: randomRadius, startAngle: startAngle, endAngle: endAngle, clockwise: goLeft)
                let archAction = SKAction.follow(archPath.cgPath, asOffset: false, orientToPath: true, duration: randomDuration)
                
                archAction.timingMode = .easeIn
                let sprite = block.sprite!
                
                // Place block sprite above the others to animate above the other blocks and begin 
                // sequence of actions which ends in a sprite removal
                sprite.zPosition = 100
                sprite.run(
                    SKAction.sequence(
                        [SKAction.group([archAction, SKAction.fadeOut(withDuration: TimeInterval(randomDuration))]),
                         SKAction.removeFromParent()]))
            }
        }
        // run completion action after duraction matches
        run(SKAction.wait(forDuration: longestDuration),completion:completion)

    }

}
