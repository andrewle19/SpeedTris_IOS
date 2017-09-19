//
//  GameController.swift
//  Tetris
//
//  Created by andrew le on 9/19/17.
//  Copyright © 2017 ZDreams. All rights reserved.
// The main game controller which will be the logic behind the game

import UIKit

// 5
// define the number of rows and colums for game view
let ColumnNum = 10
let RowNum = 20

// the starting location of blocks
let StartingColumn = 4
let StartingRow = 0

// location of preview blocks
let PreviewColumn = 12
let PreviewRow = 1

class Tetris
{
    var blockArray:Array2D<Block>
    var nextShape:Shape?
    var fallingShape:Shape?
    
    // initalize the game
    init()
    {
        fallingShape = nil
        nextShape = nil
        blockArray = Array2D<Block>(columns: ColumnNum,rows: RowNum)
    }
    
    // when game begins the next shape will be chosen if it hasnt already
    func beginGame()
    {
        if(nextShape == nil)
        {
            nextShape = Shape.random(startingColumn: PreviewColumn, startingRow: PreviewRow)
        }
    }
    
    //assigns falling shape the new shape
    func newShape() -> (fallingShape:Shape?,nextShape:Shape?)
    {
        // falling shape will be a new shape that will fall
        fallingShape = nextShape
        // assigns a new nextShape
        nextShape = Shape.random(startingColumn: PreviewColumn, startingRow: PreviewRow)
        
        // falling shape will move to starting position
        fallingShape?.moveTo(column: StartingColumn, row: StartingRow)
        
        return(fallingShape,nextShape)
    }
    
    
}
