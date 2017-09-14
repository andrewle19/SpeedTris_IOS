//
//  TshapeShape.swift
//  Tetris
//
//  Created by andrew le on 9/12/17.
//  Copyright © 2017 ZDreams. All rights reserved.
// Creats the T shaped block

class TshapeShape : Shape {
    
    
    /*
     orientation 0
    *  |0|
    |1||2||3|
    
     Orientation 90
    *|1|
     |2||0|
     |3|
     
     Orientation 180
     *
     |1||2|3|
        |0|
     
     Orientation 270
    *   |1|
     |0||2|
        |3|
     
    */
    
    override var blockRowColumnPositions: [Orientation : Array<(columnDiff: Int, rowDiff: Int)>]{
        
        return [
            
            Orientation.Zero: [(1,0),(0,1),(1,1),(2,1)],
            Orientation.Ninety: [(2,1),(1,0),(1,1),(1,2)],
            Orientation.OneEighty: [(1,2),(0,1),(1,1),(2,1)],
            Orientation.TwoSeventy: [(0,1),(1,0),(1,1),(1,2)]
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
