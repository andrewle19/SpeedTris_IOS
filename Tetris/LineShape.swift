//
//  LineShape.swift
//  Tetris
//
//  Created by andrew le on 9/12/17.
//  Copyright © 2017 ZDreams. All rights reserved.
// Creates the Line Shape Block

class LineShape: Shape{
    
    /*
        Orientations 0 and 180
        |0|*
        |1|
        |2|
        |3|
     
        Orientations 90 and 270
        |0|*|1||2||3|
     
 
 
 
    */
    
    override var blockRowColumnPositions: [Orientation : Array<(columnDiff: Int, rowDiff: Int)>]{
        
        return [
            
            Orientation.Zero:       [(0, 0), (0, 1), (0, 2), (0, 3)],
            Orientation.Ninety:     [(-1,0), (0, 0), (1, 0), (2, 0)],
            Orientation.OneEighty:  [(0, 0), (0, 1), (0, 2), (0, 3)],
            Orientation.TwoSeventy: [(-1,0), (0, 0), (1, 0), (2, 0)]
        ]
    }
    
    // bottom most blocks are 3 and 4 for a square
    override var bottomBlockForOrientations: [Orientation : Array<Block>]{
        return [
            
            Orientation.Zero: [blocks[FourthBlockIdx]],
            Orientation.Ninety: blocks,
            Orientation.OneEighty: [blocks[FourthBlockIdx]],
            Orientation.TwoSeventy: blocks
        ]
    }

}
