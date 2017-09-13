//
//  SquareShape.swift
//  Tetris
//
//  Created by andrew le on 9/12/17.
//  Copyright © 2017 ZDreams. All rights reserved.
//

class SquareShape: Shape{
    
    /* #9
    
     |0|1|
     |2|3|
     
     marks the row/column indicator for the shape
     
     the square shape will not rotate
     
    */
    
    // To change the orientations since its a square the rotation will not change 
    // set the column then row first
    override var blockRowColumnPositions: [Orientation : Array<(columnDiff: Int, rowDiff: Int)>]{
        
        return [
            
            Orientation.Zero: [(0,0),(1,0),(0,1),(1,1)],
            Orientation.Ninety: [(0,0),(1,0),(0,1),(1,1)],
            Orientation.OneEighty: [(0,0),(1,0),(0,1),(1,1)],
            Orientation.TwoSeventy: [(0,0),(1,0),(0,1),(1,1)]
        ]
    }
    
    // bottom most blocks are 3 and 4 for a square
    override var bottomBlockForOrientations: [Orientation : Array<Block>]{
        return [
            
            Orientation.Zero: [blocks[ThirdBlockIdx],blocks[FourthBlockIdx]],
            Orientation.Ninety: [blocks[ThirdBlockIdx],blocks[FourthBlockIdx]],
            Orientation.OneEighty: [blocks[ThirdBlockIdx],blocks[FourthBlockIdx]],
            Orientation.TwoSeventy: [blocks[ThirdBlockIdx],blocks[FourthBlockIdx]]
            
        
        ]
    }
    
}
