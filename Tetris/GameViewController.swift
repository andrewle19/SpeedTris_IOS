//
//  GameViewController.swift
//  Tetris
//
//  Created by andrew le on 9/30/16.
//  Copyright (c) 2016 ZDreams. All rights reserved.
///Users/Andrew/Downloads/Blocs/Sounds

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    var scene: GameScene! // declare a scene variable type is gamescene
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // configure the view
        let skView = view as! SKView // as is a forced downcast without it we are unable to use skview functions
        
        skView.isMultipleTouchEnabled = false;
        
        // create and configure the scene
        scene = GameScene(size: skView.bounds.size)
        
        scene.scaleMode = .aspectFill
        
        // display the scene
        skView.presentScene(scene)
    
        

    }
    override var prefersStatusBarHidden : Bool {
        return true
    }
}
