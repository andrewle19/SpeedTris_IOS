//
//  Array2D.swift
//  Tetris
//
//  Created by andrew le on 10/3/16.
//  Copyright © 2016 ZDreams. All rights reserved.
//

// declaring class for 2d array
class Array2D<T> {
    let columns: Int // const columns
    let rows: Int // const rows

    // declare an actual swift array that accepts any type T and ? lets us have or not have a variable
    var array: Array<T?>

    init(columns: Int, rows:Int) // intialize the columns and rows
{
    self.columns = columns
    self.rows = rows

    // #3 Intialize array structure sets up gameboard
    array = Array<T?>(repeating: nil, count: rows * columns)
}
    // supscript capable of supporting array[column,row]
    subscript(column: Int, row: Int)->T? {
       
        get // retrieve has to return something3
        {
            return array[(row*columns)+columns]
        }
        
        set(newValue) {
            array[(row*columns) + column] = newValue
        }
    }
    
    
    
}




