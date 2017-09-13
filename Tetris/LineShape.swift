//
//  LineShape.swift
//  Tetris
//
//  Created by andrew le on 9/12/17.
//  Copyright © 2017 ZDreams. All rights reserved.
//

class LineShape: Shape{
    
    /*
        Orientations 0 and 180
        |0|
        |1|
        |2|
        |3|
     
        Orientations 90 and 270
        |0||1||2||3|
     
 
 
 
    */
    
    override var blockRowColumnPositions: [Orientation : Array<(columnDiff: Int, rowDiff: Int)>]{
        
        return [
            
            Orientation.Zero: [(0,0),(0,1),(0,2),(0,3)],
            Orientation.Ninety: [(0,0),(0,1),(0,2),(0,3)],
            Orientation.OneEighty: [(0,0),(0,1),(0,2),(0,3)],
            Orientation.TwoSeventy: [(0,0),(0,1),(0,2),(0,3)]
        ]
    }
    
    // bottom most blocks are 3 and 4 for a square
    override var bottomBlockForOrientations: [Orientation : Array<Block>]{
        return [
            
            Orientation.Zero: [blocks[SecondBlockIdx],blocks[ThirdBlockIdx],blocks[FourthBlockIdx]],
            Orientation.Ninety: [blocks[FirstBlockIdx],blocks[FourthBlockIdx]],
            Orientation.OneEighty: [blocks[FirstBlockIdx],blocks[SecondBlockIdx],blocks[FourthBlockIdx]],
            Orientation.TwoSeventy: [blocks[FirstBlockIdx],blocks[FourthBlockIdx]]
            
            
        ]
    }

}
