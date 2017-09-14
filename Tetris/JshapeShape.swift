//
//  JshapeShape.swift
//  Tetris
//
//  Created by andrew le on 9/14/17.
//  Copyright © 2017 ZDreams. All rights reserved.
// Makes the J shaped Blcok


class JshapeShape : Shape
{
    /*
        Orientation 0
        |0|
        |1|
     |3||2|
     
     Orientation 90
     
     |3|
     |2||1||0|
     
     Orientation 180
     
     |2||3|
     |1|
     |0|
     
     Orientation 270
     
     |0||1||2|
           |3|
 
 
 
 
 
    */
    
    
    
    
    override var blockRowColumnPositions: [Orientation : Array<(columnDiff: Int, rowDiff: Int)>]{
        
        return [
            
            Orientation.Zero: [(1,0),(1,1),(1,2),(0,2)],
            Orientation.Ninety: [(2,1),(1,1),(0,1),(0,0)],
            Orientation.OneEighty: [(0,2),(0,1),(0,0),(1,0)],
            Orientation.TwoSeventy: [(0,0),(1,0),(2,0),(2,1)]
        ]
    }
    
    // bottom most blocks are 3 and 4 for a square
    override var bottomBlockForOrientations: [Orientation : Array<Block>]{
        return [
            
            Orientation.Zero: [blocks[ThirdBlockIdx],blocks[FourthBlockIdx]],
            Orientation.Ninety: [blocks[FirstBlockIdx],blocks[SecondBlockIdx],blocks[ThirdBlockIdx]],
            Orientation.OneEighty: [blocks[FirstBlockIdx],blocks[FourthBlockIdx]],
            Orientation.TwoSeventy: [blocks[FirstBlockIdx],blocks[SecondBlockIdx],blocks[FourthBlockIdx]]
        ]
    }

    
    
    
    
}
