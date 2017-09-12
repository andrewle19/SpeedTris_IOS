//
//  GameScene.swift
//  Tetris
//  Intializes the background
//  Created by andrew le on 9/30/16.
//  Copyright (c) 2016 ZDreams. All rights reserved.
//

import SpriteKit

//defining a constant this represents the slowest speed the pieces drop 6/10ths of a second
let TickLengthLevelOne = TimeInterval(600)

class GameScene: SKScene {
    
    //current tick length set to default tick length, lastTick keeps track the last time we experienced a tick, tick indicates it returns nothing and has no parameters but ? can take paramets
    var tick:(() -> ())?
    
    var tickLengthMillis = TickLengthLevelOne
    
    var lastTick:Date?
    
    
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
    
    
        addChild(background); // add the background
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
    
}
