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
    let url: URL
    let completionHandler: (Result<[Stop]>) -> Void

    public init(url: URL = URLs.getStops as URL, route: Route, completionHandler: @escaping (Result<[Stop]>) -> Void) {
        self.completionHandler = completionHandler

        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.query = "&route-id=\(route.id)"

        guard let urlWithParams = components?.url else {
            self.url = URL(string: "")!
            completionHandler(.error(LuasLifeKitError.unableToCreateURLWithParams))
            return
        }

        self.url = urlWithParams

    }

    public func start() {
        Alamofire.request(url).responseJSON { (response) -> Void in

            switch response.result {
            case .success(let data):

                do {
                    let stops: [Stop] = try [Stop].decode(data => "results")

                    self.completionHandler(.success(stops))
                } catch {
                    self.completionHandler(.error(error))
                }

            case .failure(let error):
                self.completionHandler(.error(error))
            }
        }
    }
}
