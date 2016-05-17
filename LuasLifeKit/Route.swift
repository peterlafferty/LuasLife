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
    public let origin:String
    public let destination:String
    public let stops:[Stop]
    
    public init(origin:String, destination:String, stops:[Stop]) {
        self.origin = origin
        self.destination = destination
        self.stops = stops
    }
}

extension Route: Decodable {
    public static func decode(j: AnyObject) throws -> Route {
        do {
            return try Route(
                origin: j => "origin",
                destination: j => "destination",
                stops: j => "stops"
            )
        }
    }
}