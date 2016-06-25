//
//  GetStopsForRouteRequest.swift
//  LuasLife
//
//  Created by Peter Lafferty on 02/03/2016.
//  Copyright © 2016 Peter Lafferty. All rights reserved.
//

import Foundation
import Alamofire
import Decodable


public struct GetRoutesRequest {
    let url: NSURL
    let completionHandler: Result<[Route]> -> Void


    public init(url: NSURL = NSURL(string: URLs.getRoutes)!, line: Line, completionHandler: Result<[Route]> -> Void) {
        self.completionHandler = completionHandler

        let components = NSURLComponents(URL: url, resolvingAgainstBaseURL: false)
        components?.query = "&operator=LUAS&routeid=\(line.name)"

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
                    _ = try Response.decode(data)

                    let routes: [Route] = try [Route].decode(data => "results")


                    self.completionHandler(.Success(routes))
                } catch {
                    self.completionHandler(.Error(error))
                }

            case .Failure(let error):
                self.completionHandler(.Error(error))
            }
        }
    }


}
