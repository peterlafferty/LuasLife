//
//  Route.swift
//  LuasLife
//
//  Created by Peter Lafferty on 29/02/2016.
//  Copyright © 2016 Peter Lafferty. All rights reserved.
//

import Foundation
import Decodable

/**
    A luas route.
    
    Type is always LUAS
 
    Names:
    - GREEN
    - RED
*/
public struct Route {
    public let type:String //should always be LUAS
    public let name:String //should be GREEN or RED until new lines are added
}

extension Route: Decodable {
    public static func decode(j: AnyObject) throws -> Route {
        return try Route(
            type: j => "operator",
            name: j => "route"
        )
    }
}