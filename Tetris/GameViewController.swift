//
//  GameViewController.swift
//  Tetris
//
//  Created by andrew le on 9/30/16.
//  Copyright (c) 2016 ZDreams. All rights reserved.
///Users/Andrew/Downloads/Blocs/Sounds

import UIKit
import SpriteKit

class GameViewController: UIViewController, TetrisDelegate, UIGestureRecognizerDelegate {

    var scene: GameScene! // declare a scene variable type is gamescene
    var tetris: Tetris!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // configure the view
        let skView = view as! SKView // as is a forced downcast without it we are unable to use skview functions
        skView.isMultipleTouchEnabled = false;
        
        // create and configure the scene
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        // set the enclosure property of Tick in game scene
        scene.tick = didTick
        
        tetris = Tetris()
        tetris.delegate = self
        tetris.beginGame()

        // display the scene
        skView.presentScene(scene)
        

    }
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    //15
    func didTick()
    {
        tetris.letShapeFall()
        self.tetris.fallingShape?.lowerShapeByOneRow()
    
        scene.redrawShape(shape: tetris.fallingShape!, completion: {})
    }
    
    
    // when user taps on screen
    @IBAction func didTap(_ sender: UITapGestureRecognizer)
    {
        tetris.rotateShape()
    }
    
    func nextShape()
    {
        let newShapes = tetris.newShape()
        guard let fallingShape = newShapes.fallingShape else
        {
            return
        }
        
        self.scene.addPreviewShapeToScene(shape: newShapes.nextShape!){}
        self.scene.movePreviewShape(shape: fallingShape)
        {
            // 16
            self.view.isUserInteractionEnabled = true
            self.scene.startTicking()
        }
        
    }
    
    func gameDidBegin(tetris: Tetris)
    {
        scene.tickLengthMillis = TickLengthLevelOne
        // following is false when restarting a new game
        if tetris.nextShape != nil && tetris.nextShape!.blocks[0].sprite == nil
        {
            scene.addPreviewShapeToScene(shape: tetris.nextShape!, completion: {})
            self.nextShape()
        }
        else
        {
            nextShape()
        }
    }
    
    func gameDidEnd(tetris: Tetris)
    {
        view.isUserInteractionEnabled = false
        scene.stopTicking()
    }
    
    func gameDidLevelUp(tetris: Tetris)
    {
        
    }
    
    func gameShapeDidDrop(tetris: Tetris)
    {
        
    }
    
    func gameShapeDidLand(tetris: Tetris)
    {
        scene.stopTicking()
        nextShape()
    }
    
    // 17 
    func gameShapeDidMove(tetris: Tetris) {
        scene.redrawShape(shape: tetris.fallingShape!, completion: {})
    }
    

}

