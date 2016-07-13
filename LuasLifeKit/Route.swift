//
//  Route.swift
//  LuasLife
//
//  Created by Peter Lafferty on 02/03/2016.
//  Copyright © 2016 Peter Lafferty. All rights reserved.
//

import Foundation
import Decodable

public struct Route {
    public let id: Int
    public let origin: Stop
    public let destination: Stop
    public let stops: [Stop]

    public init(id: Int, origin: Stop, destination: Stop, stops: [Stop]) {
        self.id = id
        self.origin = origin
        self.destination = destination
        self.stops = stops
    }
}

extension Route: Decodable {
    public static func decode(j: AnyObject) throws -> Route {
        do {
            return try Route(
                id: j => "id",
                origin: j => "from",
                destination: j => "to",
                stops: j => "stops"
            )
        }
    }
}
