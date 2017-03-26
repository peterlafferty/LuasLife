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
    let url: URL
    let completionHandler: (Result<[Route]>) -> Void

    public init(url: URL = URLs.getRoutes as URL, line: Line, completionHandler: @escaping (Result<[Route]>) -> Void) {
        self.completionHandler = completionHandler

        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.query = "&line-id=\(line.id)"

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
                    let routes: [Route] = try [Route].decode(data => "results")

                    self.completionHandler(.success(routes))
                } catch {
                    self.completionHandler(.error(error))
                }

            case .failure(let error):
                self.completionHandler(.error(error))
            }
        }
    }

}
