//
//  GameScene.swift
//  Tetris
//  Intializes the background
//  Created by andrew le on 9/30/16.
//  Copyright (c) 2016 ZDreams. All rights reserved.
// Controls the visuals of the game

import SpriteKit

// 7
let BlockSize:CGFloat = 20.0

//defining a constant this represents the slowest speed the pieces drop 6/10ths of a second
let TickLengthLevelOne = TimeInterval(600)

class GameScene: SKScene {
    
    
    // 8 
    let gameLayer = SKNode()
    let shapeLayer = SKNode()
    let LayerPosition = CGPoint(x: 6, y: -6)
    
    //current tick length set to default tick length, lastTick keeps track the last time we experienced a tick, tick indicates it returns nothing and has no parameters but ? can take paramets
    var tick:(() -> ())?
    
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
    
    
        anchorPoint = CGPoint(x: 0, y: 1.0) // set the anchor point 0:1 is the top left corner
    
        // let is the const of swift
        let background = SKSpriteNode(imageNamed: "background") // makes the background image our background
   
        background.position = CGPoint(x: 0, y: 0) // position the background with set cordinate 0:0 is bottom left corner
    
        background.anchorPoint = CGPoint(x: 0, y: 1.0)
    
    
        addChild(background) // add the background
        addChild(gameLayer) // adds the game layer
        
        let gameBoardTexture = SKTexture(imageNamed: "gameboard")
        let gameSize = CGSize(width: BlockSize*CGFloat(ColumnNum), height: BlockSize*CGFloat(RowNum))
        let gameBoard = SKSpriteNode(texture: gameBoardTexture, size: gameSize)
        
        gameBoard.anchorPoint = CGPoint(x:0,y:1.0)
        
        gameBoard.position = LayerPosition
        
        shapeLayer.position = LayerPosition
        
        shapeLayer.addChild(gameBoard)
        
        gameLayer.addChild(shapeLayer)
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        /* Called before each frame is rendered */
        
        // guard like an if, if the last tick is missing the game is in a paused state
        
        guard let lastTick = lastTick else{
            
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
    
        // 9
    func pointForColumn(column: Int, row: Int) -> CGPoint
    {
        let x = LayerPosition.x + (CGFloat(column)*BlockSize)+(BlockSize/2)
        let y = LayerPosition.y - ((CGFloat(row)*BlockSize)+(BlockSize/2))
        
        return CGPoint(x: x, y: y)
    }
    
    func addPreviewShapeToScene(shape:Shape,completion:()->())
    {
        for block in shape.blocks
        {
            //10
            var texture = textureCache[block.spriteName]
            
            if texture == nil
            {
                texture = SKTexture(imageNamed: block.spriteName)
                textureCache[block.spriteName] = texture
            }
            
            let sprite = SKSpriteNode(texture: texture)
            
            
            // 11
            sprite.position = pointForColumn(column: block.column, row: block.row-2)
            
            shapeLayer.addChild(sprite)
            block.sprite = sprite
            
            // Animation
            sprite.alpha = 0
            
            // 12
            let moveSpriteAction = SKAction.move(to: pointForColumn(column: block.column, row: block.row), duration: TimeInterval(0.2))
            
            moveSpriteAction.timingMode = .easeOut
            
            let fadeInAction = SKAction.fadeAlpha(by: 0.7, duration: 0.4)
            
            fadeInAction.timingMode = .easeOut
            
            sprite.run(SKAction.group([moveSpriteAction,fadeInAction]))
            
        }
    }
    
    func movePreviewShape(shape:Shape,completion:@escaping () -> ())
    {
        for block in shape.blocks
        {
            let sprite = block.sprite!
            
            let moveTo = pointForColumn(column: block.column, row: block.row)
            
            let moveToAction: SKAction = SKAction.move(to: moveTo, duration: 0.2)
            
            moveToAction.timingMode = .easeOut
            
            sprite.run(SKAction.group([moveToAction,SKAction.fadeAlpha(by: 1.0, duration: 0.2)]),completion: {})
            
        }
        run(SKAction.wait(forDuration: 0.2),completion: completion)
    }
    
    
    func redrawShape(shape:Shape, completion:() -> ())
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
                spirte.run(moveToAction)
            }
        }
    }
    
}
