//
//  Tram.swift
//  LuasLife
//
//  Created by Peter Lafferty on 21/03/2016.
//  Copyright © 2016 Peter Lafferty. All rights reserved.
//

import Foundation
import Decodable

public enum TramDirection: String {
    case Inbound
    case Outbound
}

public struct Tram {
    public let dueInMinutes: Int
    public let dueAtDateTime: Date
    public let destination: String
    public let direction: TramDirection
}

extension Tram: Decodable {
    public static func decode(_ j: Any) throws -> Tram {
        do {
            var stopName = try String.decode(j => "destination")
            stopName = stopName.replacingOccurrences(
                of: "LUAS ",
                with: ""
            )

            //21/03/2016 23:10:13
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"

//remove the force unwrap here
            let date = try dateFormatter.date(from: j => "arrivaldatetime")!

            //todo: the string "due" can be returned by the api should prob handle this better
            var minutes = 0
            if let minutesDecoded = try Int(String.decode(j => "duetime")) {
                minutes = minutesDecoded
            } else {
                print("Panic: \(try? String.decode(j => "duetime"))" )
            }

//todo the api returns due when it's at zero minutes
            return try Tram(
                dueInMinutes: minutes,
                dueAtDateTime: date,
                destination: stopName,
                direction: String.decode(j => "direction") == "O" ? .Outbound : .Inbound
            )
        }

    }
}
