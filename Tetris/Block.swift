//
//  Block.swift
//  Tetris
//
//  Created by andrew le on 10/12/16.
//  Copyright © 2016 ZDreams. All rights reserved.
// Deals with Creation of single bloc

import SpriteKit

// declare the number of colors avaliable to tetris
let NumberOfColors: UInt32 = 6

// enum of ints but CustomString Convertible generate human readable strings when debuging or printing values
enum BlockColor: Int, CustomStringConvertible {
    
    // provide full list of enum options one for each color begging with 0 and ending with 5 yellow
    case blue = 0, orange, violet, red, teal, yellow
    
    // computed property called sprite name, computed property is one that is a typical variable but when 
    // accessing it a code bloc generates its value each time like a get function being called
    // outputs file name for each of the colors
    var spriteName: String {
    
        let model = UIDevice.current.model

        if (model == "iPad")
        {
            print("here")
            switch self
            {
            case .blue:
                return "blue2x"
            case .orange:
                return "orange2x"
            case .violet:
                return "violet2x"
            case .red:
                return "red2x"
            case .teal:
                return "teal2x"
            case .yellow:
                return "yellow2x"
            }
        }
        else
        {
            switch self
            {
            case .blue:
                return "blue"
            case .orange:
                return "orange"
            case .violet:
                return "violet"
            case .red:
                return "red"
            case .teal:
                return "teal"
            case .yellow:
                return "yellow"
            }
        }

    }
    
    // computed property returns the sprite color to describe the color
    var description: String {
        return self.spriteName
    }
    
    // use random to return a random choice among block colors Uses rawValue to create an enum which is assigned to numerical value of 6 which is our colors
    static func random() -> BlockColor {
        return BlockColor(rawValue:Int(arc4random_uniform(NumberOfColors)))!
    }
}

    // BLock is a class that implements customstring convertible and hasahable protocols, hasahble allows us to store block in 2dd Array
    class Block: Hashable , CustomStringConvertible {
    
    // Constant Block color a block color cant be changed
    let color: BlockColor
    
    // Column and Row represent the Block location on our game board, SKSPRITENODE is the visual element of the Block which GameScence will us to render and animate each block
        // properties
    var column: Int
        
    var row: Int
    
    var sprite: SKSpriteNode?
        
    
    // Recovers the sprites file name
    var spriteName: String
    {
        return color.spriteName
    }
    
    // returns and exclusive row and column to generate a unique location for each block
        var hashValue: Int
            {
            return self.column ^ self.row
        }
    
    // Adhere to CustomString Protocol returns the column then the row
        var description: String
            {
            return "\(color): [\(column), \(row)]"
        }
    
        init(column:Int, row: Int, color: BlockColor )
        {
            self.column = column
            
            self.row = row
            
            self.color = color
        }
        
    }


// create custom operator ==, compares one Block with another if they are both true then it means their color and location are the same // rule of tetris
func ==(lhs: Block, rhs: Block) -> Bool
{
    return lhs.column == rhs.column && lhs.row == rhs.row && lhs.color.rawValue == rhs.color.rawValue
}
    

