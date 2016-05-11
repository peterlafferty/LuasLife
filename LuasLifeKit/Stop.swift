//
//  Stop.swift
//  LuasLife
//
//  Created by Peter Lafferty on 02/03/2016.
//  Copyright © 2016 Peter Lafferty. All rights reserved.
//

import Foundation
import Decodable


/// A 🚉 Stop.
public struct Stop {
    let id:String
    let name:String
}

extension Stop: Decodable {
    public static func decode(j: AnyObject) throws -> Stop {
        do {
            let stopName:String = try j => "displaystopid"
            //stopName.stringByPaddingToLength(10, withString: " ", startingAtIndex: 0)
            return try Stop(
                id: j => "stopid",
                name: stopName.stringByReplacingOccurrencesOfString("LUAS ", withString: "")
            )
        }
        
    }
}