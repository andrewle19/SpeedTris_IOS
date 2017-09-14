//
//  SShape.swift
//  Tetris
//
//  Created by andrew le on 9/14/17.
//  Copyright © 2017 ZDreams. All rights reserved.
// Makes the S shaped block


/*
 
 Orientation 0
 |0|
 |1||2|
    |3|
 
 Orientation 90
    |1||0|
 |3||2|
 
 Orientation 180
 |0|
 |1||2|
    |3|
 
 Orientation 270
    |1||0|
 |3||2|
 
 
 */






class SShape : Shape {
    
    
    
    
    override var blockRowColumnPositions: [Orientation : Array<(columnDiff: Int, rowDiff: Int)>]{
        
        return [
            
            Orientation.Zero: [(0,0),(0,1),(1,1),(1,2)],
            Orientation.Ninety: [(2,0),(1,0),(1,1),(0,1)],
            Orientation.OneEighty: [(0,0),(0,1),(1,1),(1,2)],
            Orientation.TwoSeventy: [(2,0),(1,0),(1,1),(0,1)]
        ]
    }
    
    // bottom most blocks are 3 and 4 for a square
    override var bottomBlockForOrientations: [Orientation : Array<Block>]{
        return [
            
            Orientation.Zero: [blocks[SecondBlockIdx],blocks[FourthBlockIdx]],
            Orientation.Ninety: [blocks[FirstBlockIdx],blocks[ThirdBlockIdx],blocks[FourthBlockIdx]],
            Orientation.OneEighty: [blocks[SecondBlockIdx],blocks[FourthBlockIdx]],
            Orientation.TwoSeventy: [blocks[FirstBlockIdx],blocks[ThirdBlockIdx],blocks[FourthBlockIdx]]
        ]
    }

    
    
    
}
