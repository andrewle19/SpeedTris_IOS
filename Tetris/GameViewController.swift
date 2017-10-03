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
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    // keep track of last point on screen which movement occured
    var panPointReference: CGPoint?
    
    @IBAction func didPan(_ sender: UIPanGestureRecognizer)
    {
        // measure the distance the users finger traveled
        let currentPoint = sender.translation(in: self.view)
        
        if let ogPoint = panPointReference
        {
            // check whether x translation has crossed 90% of Block size
            if abs(currentPoint.x - ogPoint.x) > (BlockSize * 0.9)
            {
                
                // velocity corresponding to which side the user wants to go
                if sender.velocity(in: self.view).x > CGFloat(0)
                {
                    tetris.moveShapeRight()
                    panPointReference = currentPoint
                }
                else
                {
                    tetris.moveShapeLeft()
                    panPointReference = currentPoint
                }
            }
        }
        else if sender.state == .began
        {
            panPointReference = currentPoint
        }
    }
    
    // brings shape down faster when swiped down
    @IBAction func didSwipe(_ sender: UISwipeGestureRecognizer)
    {
        tetris.dropShape()
    }
    // allows gesture recognizers to work in tandem with one another
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return true
    }
    
    // Allows Gestures to be used simulatanosly with one another
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UISwipeGestureRecognizer
        {
            if otherGestureRecognizer is UIPanGestureRecognizer
            {
                return true
            }
        }
        else if gestureRecognizer is UIPanGestureRecognizer
        {
            if otherGestureRecognizer is UITapGestureRecognizer
            {
                return true
            }
        }
        
        return false
    }
    
    
    
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
    // hide the task bar
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func didTick()
    {
        tetris.letShapeFall()
    }
    
    
    // when user taps on screen
    @IBAction func didTap(_ sender: UITapGestureRecognizer)
    {
        tetris.rotateShape()
    }
    
    
    // gets the next shape
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
            
            self.view.isUserInteractionEnabled = true
            self.scene.startTicking()
        }
        
    }
    
    // check if the game has began
    func gameDidBegin(tetris: Tetris)
    {
        // reset scores and speed of ticks
        levelLabel.text = "\(tetris.level)"
        scoreLabel.text = "\(tetris.score)"
        scene.tickLengthMillis = TickLengthLevelOne
        
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
        
        // destroy all blocks when lose then start game over again
        scene.animateCollapsingLines(linesToRemove: tetris.removeAllBlocks(), fallenBlocks: tetris.removeAllBlocks())
        {
            tetris.beginGame()
        }
    }
    
    func gameDidLevelUp(tetris: Tetris)
    {
        
        // as you level up the speed of the blocks will drop faster
        levelLabel.text = "\(tetris.level)"
        
        if scene.tickLengthMillis > 250
        {
            scene.tickLengthMillis -= 100
        }
        else if scene.tickLengthMillis > 100 && scene.tickLengthMillis < 250
        {
            scene.tickLengthMillis -= 50
        }
        else
        {
            scene.tickLengthMillis -= 20
        }
       
        
    }
    
    func gameShapeDidDrop(tetris: Tetris)
    {
        // stops tick redraw shape in new location then drop
        scene.stopTicking()
        
        scene.redrawShape(shape: tetris.fallingShape!){
            tetris.letShapeFall()
        }
    }
    
    func gameShapeDidLand(tetris: Tetris)
    {
        scene.stopTicking()
        self.view.isUserInteractionEnabled = false
        
        // check completed lines when shape lands
        // if removed at any lines we update score label to newest score then animate
        let removedLines = tetris.removeCompletedLines()
        
        if removedLines.linesRemoved.count > 0
        {
            self.scoreLabel.text = "\(tetris.score)"
            // animate the lines exploding
            scene.animateCollapsingLines(linesToRemove: removedLines.linesRemoved, fallenBlocks: removedLines.fallenBlocks)
            {
                // recursive fall to invoke itself, blocks fallen into their new location
                self.gameShapeDidLand(tetris: tetris)
            }
        }
        else
        {
            nextShape()
        }
        
    }
    
    func gameShapeDidMove(tetris: Tetris) {
        scene.redrawShape(shape: tetris.fallingShape!, completion: {})
    }
    

}

