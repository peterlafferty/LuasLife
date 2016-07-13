//
//  GetStopsRequest.swift
//  LuasLife
//
//  Created by Peter Lafferty on 13/07/2016.
//  Copyright © 2016 Peter Lafferty. All rights reserved.
//

import Foundation
import Alamofire
import Decodable

public struct GetStopsRequest {
    let url: NSURL
    let completionHandler: Result<[Stop]> -> Void


    public init(url: NSURL = URLs.getStops, route: Route, completionHandler: Result<[Stop]> -> Void) {
        self.completionHandler = completionHandler

        let components = NSURLComponents(URL: url, resolvingAgainstBaseURL: false)
        components?.query = "&route-id=\(route.id)"

        guard let urlWithParams = components?.URL else {
            self.url = NSURL()
            completionHandler(.Error(LuasLifeKitError.UnableToCreateURLWithParams))
            return
        }

        self.url = urlWithParams

    }

    public func start() {
        Alamofire.request(.GET, url).responseJSON { (response) -> Void in

            switch response.result {
            case .Success(let data):

                do {
                    let stops: [Stop] = try [Stop].decode(data => "results")


                    self.completionHandler(.Success(stops))
                } catch {
                    self.completionHandler(.Error(error))
                }

            case .Failure(let error):
                self.completionHandler(.Error(error))
            }
        }
    }
}
