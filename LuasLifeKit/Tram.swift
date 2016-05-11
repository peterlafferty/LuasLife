//
//  Tram.swift
//  LuasLife
//
//  Created by Peter Lafferty on 21/03/2016.
//  Copyright © 2016 Peter Lafferty. All rights reserved.
//

import Foundation
import Decodable

public enum TramDirection:String {
    case Inbound
    case Outbound
}

public struct Tram {
    let dueInMinutes:Int
    let dueAtDateTime:NSDate
    let destination:String
    let direction:TramDirection
}

extension Tram: Decodable {
    public static func decode(j: AnyObject) throws -> Tram {
        do {
            var stopName = try String.decode(j => "destination")
            stopName = stopName.stringByReplacingOccurrencesOfString(
                "LUAS ",
                withString: ""
            )
            
            //21/03/2016 23:10:13
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
            let date = try dateFormatter.dateFromString(j => "arrivaldatetime")!
            //let date = try ISO8601DateFormatter.dateFromString(j => "arrivaldatetime")

            return try Tram(
                dueInMinutes: Int(String.decode(j => "duetime"))!,
                dueAtDateTime: date,
                destination: stopName,
                direction: String.decode(j => "direction") == "O" ? .Outbound : .Inbound
            )
        }
        
    }
}