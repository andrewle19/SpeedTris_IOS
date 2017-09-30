//
//  GameScene.swift
//  Tetris
//  Intializes the background
//  Created by andrew le on 9/30/16.
//  Copyright (c) 2016 ZDreams. All rights reserved.
// Controls the visuals of the game

import SpriteKit

// Define the size of each block sprite 20.0 X 20.0
let BlockSize:CGFloat = 20.0

//defining a constant this represents the slowest speed the pieces drop 6/10ths of a second
let TickLengthLevelOne = TimeInterval(550)

class GameScene: SKScene {
    
    
    // Layer Position is an offset from the edge of the screen
    let gameLayer = SKNode()
    let shapeLayer = SKNode()
    let LayerPosition = CGPoint(x: 6, y: -6)
    
    //current tick length set to default tick length, lastTick keeps track the last time we experienced a tick,
    // tick indicates it returns nothing and has no parameters but ? can take paramets
    var tick:(()->())?
    
    var tickLengthMillis = TickLengthLevelOne
    
    var lastTick:Date?
    
    var textureCache = Dictionary<String,SKTexture>()
    
    required init(coder aDecoder: NSCoder)
    {
        fatalError("NSCoder not supported")
    }
    
    // initalizae the game scene
    override init(size: CGSize)
    {
        super.init(size: size) // super comes from super class. init is to intialize without parameters
        
        print("Scene Init")
        self.backgroundColor = UIColor(red: 0.31, green: 0.31, blue: 0.31, alpha: 1)
        anchorPoint = CGPoint(x: 0, y: 1.0) // set the anchor point 0:1 is the top left corner
        
        /* let is the const of swift
        let background = SKSpriteNode(imageNamed: "background") // makes the background image our background
        
         position the background with set cordinate 0:0 is bottom left corner
        background.position = CGPoint(x: 0, y: 0)
        background.anchorPoint = CGPoint(x: 0, y: 1.0)
        addChild(background)  add the background */

        addChild(gameLayer) // adds the game layer
        
        let gameBoardTexture = SKTexture(imageNamed: "gameboard.png")
        let gameBoard = SKSpriteNode(texture: gameBoardTexture, size: CGSize(width: BlockSize * CGFloat(ColumnNum), height: BlockSize * CGFloat(RowNum)))
        gameBoard.anchorPoint = CGPoint(x:0, y:1.0)
        gameBoard.position = LayerPosition
        
        shapeLayer.position = LayerPosition
        
        shapeLayer.addChild(gameBoard) // add the gameBoard layer
        
        gameLayer.addChild(shapeLayer) // add the shape layer over the gameBoard layer
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
    
    // 
    func movePreviewShape(shape:Shape,completion:@escaping () -> ())
    {
        
        print("move Preview called")
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
