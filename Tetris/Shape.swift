//
//  Shape.swift
//  Tetris
//
//  Created by andrew le on 9/12/17.
//  Copyright © 2017 ZDreams. All rights reserved.
// Makes the shape of the blocks

import SpriteKit

let NumOrientations: UInt32 = 4

// enum helper which defines the shapes orientation
enum Orientation: Int, CustomStringConvertible{
    
    case Zero = 0, Ninety, OneEighty, TwoSeventy
    
    var description: String{
        
        switch self{
            case .Zero:
                return "0"
            case .Ninety:
                return "90"
            case .OneEighty:
                return "180"
            case .TwoSeventy:
                return "270"
            
        }
    }

    static func random() -> Orientation {
    
        return Orientation(rawValue: Int(arc4random_uniform(NumOrientations)))!
    
    }


// function returns the next orientation
    static func rotate(orientation:Orientation, clockwise: Bool) -> Orientation {
        
        var rotated = orientation.rawValue + (clockwise ? 1: -1)
        
        if (rotated > Orientation.TwoSeventy.rawValue)
        {
            rotated = Orientation.Zero.rawValue
        }
        else if (rotated < 0)
        {
            rotated = Orientation.TwoSeventy.rawValue
        }
        
        return Orientation(rawValue:rotated)!
    }
}


// the number of total shape varieties
let NumShapeTypes: UInt32 = 7

// shape indexes
let FirstBlockIdx: Int = 0
let SecondBlockIdx: Int = 1
let ThirdBlockIdx: Int = 2
let FourthBlockIdx: Int = 3

class Shape: Hashable, CustomStringConvertible{
    
    // the color of the shape
    let color:BlockColor
    
    // the blocks comprising the shape
    var blocks = Array<Block>()
    
    // The current orientation of the shape
    var orientation: Orientation
    
    // the column and row representing the shape's anchor point
    var column,row:Int
    
    //required Overrides
    // subclasess must override this property
    
    var blockRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>] {
        return [:]
    }
    
    //#3 
    // subclasses must override this property
    var bottomBlockForOrientations: [Orientation: Array<Block>]{
        return [:]
    }
    
    //computed property that returns the bottom of the shapes orientation
    var bottomBlocks:Array<Block>{
        
        guard let bottomBlocks = bottomBlockForOrientations[orientation] else{
        
            return []

        }
    
    return bottomBlocks
    }

    // Hashable
    var hashValue:Int{
        
    // iterates through block arrary, exclusive or each blocks hash value to create single hash value
        return blocks.reduce(0){ $0.hashValue ^ $1.hashValue}
        
    }
    // custom string convertible
    var description: String{
        return "\(color) block facing \(orientation): \(blocks[FirstBlockIdx]),\(blocks[SecondBlockIdx]),\(blocks[ThirdBlockIdx]),\(blocks[FourthBlockIdx])"
    }
    
    // intialize the shape class
    init(column:Int,row:Int,color:BlockColor,orientation:Orientation) {
            self.color = color
            self.column = column
            self.row = row
            self.orientation = orientation
            initializeBlocks()
    }
    
    // assigns the given row/column values while generating a random color and random orientation
    convenience init(column:Int,row:Int){
        self.init(column:column,row:row,color:BlockColor.random(),orientation:Orientation.random())
    }

    // final means it cannot be ovveridden, Shape and sub classes must use this func ction
    final func initializeBlocks(){
        guard let blockRowColumnTranslations = blockRowColumnPositions[orientation] else {
            return
        }
        
        /* #map function creats the blocks arrays, executes the provied code block for each object found in the
         array, block must return a BLock object. map adds each Block returned by our code to blocks
        */
        blocks = blockRowColumnTranslations.map {
            (diff) -> Block in
            
                return Block(column: column + diff.columnDiff, row: row + diff.rowDiff, color: color)
        }
    
    }
    // rotates block returns the new block postion given an orientation
    final func rotateBlocks(orientation: Orientation)
    {
        guard let blockRowColumnTranslation:Array<(columnDiff: Int, rowDiff: Int)> = blockRowColumnPositions[orientation]
        else{
                return
        }
    
        // idx is index to loop through array, diff refers to the column differences
        for (idx, diff) in blockRowColumnTranslation.enumerated()
        {
            blocks[idx].column = column + diff.columnDiff
    
            blocks[idx].row = row + diff.rowDiff
    
        }
    }
    
    // rotate shape clockwise
    final func rotateClockwise()
    {
        let newOrientation = Orientation.rotate(orientation: orientation, clockwise: true)
        
        rotateBlocks(orientation: newOrientation)
        
        orientation = newOrientation
    }
    
    // rotate shape counter clockwise
    final func rotateCounterClockwise()
    {
        let newOrientation = Orientation.rotate(orientation: orientation, clockwise: false)
        
        rotateBlocks(orientation: newOrientation)
        
        orientation = newOrientation
    }
    
    
    // Method adjusts the rows and columns of the blocks
    final func shiftBy(columns: Int,rows: Int)
    {
        self.column += columns
        self.row += rows
        
        for block in blocks
        {
            block.column += columns
            block.row += rows
        }
    }
    
    // lowers the shape by 1 row at a time like tetris
    final func lowerShapeByOneRow()
    {
        shiftBy(columns: 0, rows:1)
    }
    
    // raises shape by one row
    final func raiseShapeByOneRow()
    {
        shiftBy(columns: 0, rows: -1)
    }
    
    // Shift right by one column
    final func shiftRightByOneColumn()
    {
        shiftBy(columns: 1, rows:0)
    }
    
    // Shift left by one column
    final func shiftLeftByOneColumn()
    {
        shiftBy(columns: -1, rows:0)
    }
    
    
    // position the columns and blocks before rotating to acutual orientation for acuracy
    final func moveTo(column: Int, row: Int)
    {
        self.column = column
        self.row = row
        
        rotateBlocks(orientation: orientation)
        
    }
    
    // Generates a random shape 
    final class func random(startingColumn:Int, startingRow: Int) -> Shape{
        switch Int(arc4random_uniform(NumShapeTypes))
        {
            
        case 0:
            return SquareShape(column: startingColumn, row: startingRow)
        case 1:
            return LineShape(column: startingColumn, row: startingRow)
        case 2:
            return TshapeShape(column: startingColumn, row: startingRow)
        case 3:
            return LShape(column: startingColumn, row: startingRow)
        case 4:
            return JshapeShape(column: startingColumn, row: startingRow)
        case 5:
            return SShape(column: startingColumn, row: startingRow)
        default:
            return ZShape(column: startingColumn, row: startingRow)

            
        }
    }
    
}

func ==(lhs: Shape, rhs: Shape) -> Bool{
    
    return lhs.row == rhs.row && lhs.column == rhs.column

}

















