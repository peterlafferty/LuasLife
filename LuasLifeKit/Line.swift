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

    Names:
    - GREEN
    - RED
*/
public struct Line {
    public let id: Int
    public let name: String
    public let numberOfRoutes: Int

    public init(id: Int, name: String, numberOfRoutes: Int = 0) {
        self.id = id
        self.name = name
        self.numberOfRoutes = numberOfRoutes
    }
}

extension Line: Decodable {
    public static func decode(j: AnyObject) throws -> Line {
        return try Line(
            id: j => "id",
            name: j => "name",
            numberOfRoutes: j => "numberOfRoutes"
        )
    }
}
