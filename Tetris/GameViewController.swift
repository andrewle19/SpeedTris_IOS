//
//  GameViewController.swift
//  Tetris
//
//  Created by andrew le on 9/30/16.
//  Copyright (c) 2016 ZDreams. All rights reserved.
/// Assets by SwiftTres

import GoogleMobileAds
import UIKit
import SpriteKit




class GameViewController: UIViewController, TetrisDelegate, UIGestureRecognizerDelegate, GADInterstitialDelegate {

    var advertisement: GADInterstitial!
    var scene: GameScene! // declare a scene variable type is gamescene
    var tetris: Tetris!
    var start : Bool = false // variable to descide if game has started yet
    var count : Int = 1 // amount of times the user has played the game
   
    // First function to load in
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //initialize advertisement
        advertisement = createAndLoadInterstitial()

        // allow the advertisement request to be testested
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID,"2077ef9a63d2b398840261c8221a0c9b" ];
       
        
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
        // displays the scene
        scene.displayPlayMsg()
        // display the scene
        skView.presentScene(scene)
        
    }
    
    
    // used to create and load advertisements
    func createAndLoadInterstitial() -> GADInterstitial
    {
        // change this string into unique admob string
        //let interstitialAd = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/1033173712")
        let interstitialAd = GADInterstitial(adUnitID: "ca-app-pub-1852088920684374/1279596465")
        interstitialAd.delegate = self
        interstitialAd.load(GADRequest())
        return interstitialAd
    }
    
    // when the advertisement is dismissed load another one
    func interstitialDidDismissScreen(_ ad: GADInterstitial)
    {
        advertisement = createAndLoadInterstitial()
    }
    
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
        if (start != false)
        {
            tetris.dropShape()
        }
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
        // if the game hasnt started on tap start the game
        if (start == false)
        {
            
            start = true
            scene.removePlayMsg()
            tetris.beginGame()
        }
        else
        {
            tetris.rotateShape()
        }
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
        scene.levelLabel.text = "\(tetris.level)"
        scene.scoreLabel.text = "\(tetris.score)"
        scene.highScoreLabel.text = "\(tetris.highscore)"
        scene.tickLengthMillis = TickLengthLevelOne
        tetris.LevelThreshold = 50
        
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
        
        scene.playSound(sound: "Sounds/gameover.mp3")
        // destroy all blocks when lose then start game over again
        scene.animateCollapsingLines(linesToRemove: tetris.removeAllBlocks(), fallenBlocks: tetris.removeAllBlocks())
        {
            self.view.isUserInteractionEnabled = true
            
            
            // saves the local highscore
            tetris.saveHighScore()
           
            print("user default value: \(UserDefaults.standard.value(forKey: "HIGHSCORE")!) ")
            
            // increment the count of games played
            self.count += 1
            print("count: \(self.count)")
            
            // Each 3rd game over show an advertisement
            if(self.count % 2 == 0)
            {
                // check if the advertisement is ready then present it
                if self.advertisement.isReady
                {
                    self.advertisement.present(fromRootViewController: self)
                }
               
            }
           
            
            // displays the play msg again
            self.scene.displayPlayMsg()
            
            // game has not started yet
            self.start = false
        }
    
    }
    
    func gameDidLevelUp(tetris: Tetris)
    {
        scene.playSound(sound: "Sounds/levelup.mp3")
        // as you level up the speed of the blocks will drop faster
        scene.levelLabel.text = "\(tetris.level)"
        
        if scene.tickLengthMillis > 250
        {
            scene.tickLengthMillis -= 100
        }
        else if scene.tickLengthMillis > 50 && scene.tickLengthMillis < 150
        {
            scene.tickLengthMillis -= 50
        }
        else if scene.tickLengthMillis > 0 && scene.tickLengthMillis < 50
        {
            scene.tickLengthMillis -= 10
        }

       
        
    }
    
    func gameShapeDidDrop(tetris: Tetris)
    {
        // stops tick redraw shape in new location then drop
        scene.stopTicking()
        
        scene.redrawShape(shape: tetris.fallingShape!){
            tetris.letShapeFall()
        }
        //scene.playSound(sound: "Sounds/drop.mp3")
    }
    
    func gameShapeDidLand(tetris: Tetris)
    {
        scene.stopTicking()
        self.view.isUserInteractionEnabled = false
        
        // check completed lines when shape lands
        // if removed at any lines we update score label to newest score then animate
        let removedLines = tetris.removeCompletedLines()
        scene.playSound(sound: "Sounds/drop.mp3")
        
        if removedLines.linesRemoved.count > 0
        {
            scene.playSound(sound: "Sounds/remove.mp3")
            // checks amount of lines removed
            // if removed lines is > 4 then slow down drop rate
            if(removedLines.linesRemoved.count >= 4)
            {
                scene.tickLengthMillis += 20
                print("Speed: \(scene.tickLengthMillis)")
            }
   
            scene.scoreLabel.text = "\(tetris.score)"
            scene.highScoreLabel.text = "\(tetris.highscore)"
          
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

