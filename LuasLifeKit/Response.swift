//
//  Response.swift
//  LuasLife
//
//  Created by Peter Lafferty on 01/03/2016.
//  Copyright © 2016 Peter Lafferty. All rights reserved.
//

import Foundation
import Decodable

/// Represents a response from the dublinked api
public struct Response {
    public let errorCode: String //should be an int
    public let errorMesssage: String
    public let numberOfResults: Int
    public let timestamp: String
}

extension Response: Decodable {
    public static func decode(_ j: Any) throws -> Response {
        return try Response(
            errorCode: j => "errorcode",
            errorMesssage: j => "errormessage",
            numberOfResults: j => "numberofresults",
            timestamp: j => "timestamp"
        )
    }
}
