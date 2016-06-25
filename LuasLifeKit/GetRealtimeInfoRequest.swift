//
//  GetRealtimeInfoRequest.swift
//  LuasLife
//
//  Created by Peter Lafferty on 21/03/2016.
//  Copyright © 2016 Peter Lafferty. All rights reserved.
//

import Foundation
import Alamofire
import Decodable

public struct GetRealtimeInfoRequest {
    let url: NSURL
    let completionHandler: Result<[Tram]> -> Void

    public init(url: NSURL = NSURL(string: URLs.getRealTimeInfo)!,
                stop: Stop, completionHandler: Result<[Tram]> -> Void) {
        self.completionHandler = completionHandler

        let components = NSURLComponents(URL: url, resolvingAgainstBaseURL: false)
        components?.query = "&operator=LUAS&stopid=\(stop.id)"

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
                    let trams: [Tram] = try [Tram].decode(data => "results")
                    self.completionHandler(.Success(trams))
                } catch {
                    self.completionHandler(.Error(error))
                }

            case .Failure(let error):
                self.completionHandler(.Error(error))
            }
        }

    }


}
