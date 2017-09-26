//
//  GameController.swift
//  Tetris
//
//  Created by andrew le on 9/19/17.
//  Copyright © 2017 ZDreams. All rights reserved.
// The main game controller which will be the logic behind the game

import UIKit

// define the number of rows and colums for game view
let ColumnNum = 10
let RowNum = 20

// the starting location of blocks
let StartingColumn = 4
let StartingRow = 0

// location of preview blocks
let PreviewColumn = 12
let PreviewRow = 1

// score
let PointsPerLine = 10
let LevelThreshold = 500

// checks whether the user is making legal moves and reacts acordingly (RULES)
protocol TetrisDelegate {
    // called when current round of Tetris ends
    func gameDidEnd(tetris: Tetris)
    // called after a game has began
    func gameDidBegin(tetris: Tetris)
    // called when the falling shape has become part of the game board
    func gameShapeDidLand(tetris: Tetris)
    // called when falling shape changed its location
    func gameShapeDidMove(tetris: Tetris)
    //called when the falling shape has changed its location after being droped
    func gameShapeDidDrop(tetris: Tetris)
    // called when the game has reached a new level
    func gameDidLevelUp(tetris: Tetris)
}

class Tetris
{
    var blockArray:Array2D<Block>
    var nextShape:Shape?
    var fallingShape:Shape?
    var delegate: TetrisDelegate?
    
    // starting score and level
    var score = 0
    var level = 1
    
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
        delegate?.gameDidBegin(tetris: self)
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
        
        // detect the ending of a game
        // game ends when shape is desinated starting colides with existing block
        guard detectIllegalPlacement() == false else
        {
            nextShape = fallingShape
            nextShape!.moveTo(column: PreviewColumn, row: PreviewRow)
            endGame()
            return(nil,nil)
        }
        return(fallingShape,nextShape)
    }
    
    
    
    // Checks the block boundary conditions
    func detectIllegalPlacement()->Bool
    {
        // determines if the block exceeds legal size of the gameboard
        guard let shape = fallingShape else
        {
            return false
        }
    
        for block in shape.blocks
        {
            // check wheather the shape overlaps other shapes
            if block.column < 0 || block.column >= ColumnNum || block.row < 0 || block.row >= RowNum
            {
                return true
            }
            else if blockArray[block.column, block.row] != nil
            {
                return true
            }
        }
        return false
    }
    
    // Drops shape until it detects illegal placement
    func dropShape()
    {
        guard let shape = fallingShape else
        {
            return
        }
        
        while detectIllegalPlacement() == false
        {
            shape.lowerShapeByOneRow()
        }
        
        shape.raiseShapeByOneRow()
        
        delegate?.gameShapeDidDrop(tetris: self)
    }
    
    //  Call every tick which attempts to lower shape by one row and ends game if illegal placement
    func letShapeFall()
    {
        guard let shape = fallingShape else
        {
            return
        }
        
        shape.lowerShapeByOneRow()
        
        if detectIllegalPlacement()
        {
            shape.raiseShapeByOneRow()
            
            if detectIllegalPlacement()
            {
                endGame()
            }
            else
            {
                settleShape()
            }
        }
        else
        {
            delegate?.gameShapeDidMove(tetris: self)
            
            if detectTouch()
            {
                settleShape()
            }
        }
    }
    
    // Allows the user to rotate a shape clockwise if it is a valid move, let the delegate know shape is moved
    func rotateShape()
    {
        guard let shape = fallingShape else
        {
            return
        }
        
        shape.rotateClockwise()
        
        guard detectIllegalPlacement() == false else
        {
            shape.rotateCounterClockwise()
            
            return
        }
        
        delegate?.gameShapeDidMove(tetris: self)
    }
    
    // Allows the user to move shape Right if it is valid moves tells delegate if moved
    func moveShapeRight()
    {
        guard let shape = fallingShape else
        {
            return
        }
        
        shape.shiftRightByOneColumn()
        
        guard detectIllegalPlacement() == false else
        {
            shape.shiftRightByOneColumn()
            
            return
        }
        
        delegate?.gameShapeDidMove(tetris: self)

    }

    // Allows the user to move shape right if it is valid moves tells delegate if moved
    func moveShapeLeft()
    {
        guard let shape = fallingShape else
        {
            return
        }
        
        shape.shiftLeftByOneColumn()
        
        guard detectIllegalPlacement() == false else
        {
            shape.shiftLeftByOneColumn()
            
            return
        }
        
        delegate?.gameShapeDidMove(tetris: self)
        
    }
    
    // Adds falling shape to collection of blocks in Tetris, nul falling shape when fallish shape is part of game 
    // board/ notify delegate a new shape settling onto the game board
    func settleShape()
    {
        guard let shape = fallingShape else
        {
            return
        }
        
        for block in shape.blocks
        {
            blockArray[block.column,block.row] = block
        }
        fallingShape = nil
        delegate?.gameShapeDidLand(tetris: self)
    }
    
    // Detects when a shape touches another shape or the bottom of the board returns true when these occur
    func detectTouch() -> Bool
    {
        guard let shape = fallingShape else
        {
            return false
        }
        
        for bottomBlock in shape.bottomBlocks
        {
            if bottomBlock.row == RowNum - 1 || blockArray[bottomBlock.column,bottomBlock.row+1] != nil
            {
                return true
            }
        }
        
        return false
    }
    
    // ends game
    func endGame()
    {
        score = 0
        level = 1
        delegate?.gameDidEnd(tetris: self)
    }
    
    // Function will remove lines whne completed returning a tuble of two arrays
    func removeCompletedLines() -> (linesRemoved: Array<Array<Block>>, fallenBlocks: Array<Array<Block>>)
    {
        var removedLines = Array<Array<Block>>()
        for row in (1..<RowNum).reversed()
        {
            var rowOfBlocks = Array<Block>()
            // loop through all the columns and row and if a set ends with 10 blocks total count that as
            // removed line and add it to return value
            for column in 0..<ColumnNum
            {
                guard let block = blockArray[column,row] else
                {
                    continue
                }
            
                rowOfBlocks.append(block)
            }
        
            if rowOfBlocks.count == ColumnNum
            {
                removedLines.append(rowOfBlocks)
            
                for block in rowOfBlocks
                {
                    blockArray[block.column,block.row] = nil
                }
            }
        }
        // check to see if we recovered any lines at all if not return empty arrays
        if removedLines.count == 0
        {
            return ([],[])
        }
        
        // add points based on number of lines created and their level,
        let pointsEarned = removedLines.count * PointsPerLine * level
        
        score += pointsEarned
        
        // level up inform the delegate
        if score >= level * LevelThreshold
        {
            level += 1
            delegate?.gameDidLevelUp(tetris: self)
        }
        
        var fallenBlocks = Array<Array<Block>>()
        
        for column in 0..<ColumnNum
        {
            var fallenBlocksArray = Array<Block>()
            
            
            // Count starting in the left most column and above the bottom most removed line, count
            // upwards towrds the top of the board lower blocks on gameboard and lower it as far as possible
            // Fill FallenBlocks with sub array with blocks that fell into a new position
            for row in (1..<removedLines[0][0].row).reversed()
            {
                guard let block = blockArray[column,row] else
                {
                    continue
                }
            
                var newRow = row
            
                while (newRow < RowNum - 1 && blockArray[column, newRow + 1] == nil)
                {
                    newRow += 1
                }
            
                block.row = newRow
            
                blockArray[column,row] = nil
            
                blockArray[column,newRow] = block
            
                fallenBlocksArray.append(block)
            }
                if fallenBlocksArray.count > 0
                {
                    fallenBlocks.append(fallenBlocksArray)
                }
        }
        return (removedLines,fallenBlocks)
    }
        
    // function removes block from the UI
    // loops through and creates row of blocks in order to animate game scene of the board
    // nulifies location in the block array to empty it entirely for new game
    func removeAllBlocks() -> Array<Array<Block>>
    {
        var allBlocks = Array<Array<Block>>()
        for row in 0..<RowNum
        {
            var rowOfBlocks = Array<Block>()
            for column in 0..<ColumnNum
            {
                guard let block = blockArray[column,row] else
                {
                    continue
                }
                rowOfBlocks.append(block)
                blockArray[column,row] = nil
            }
            allBlocks.append(rowOfBlocks)
        }
        return allBlocks
    }

    
}
