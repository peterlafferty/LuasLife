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
    let url: URL
    let completionHandler: (Result<[Tram]>) -> Void

    public init(url: URL = URL(string: URLs.getRealTimeInfo)!,
                stop: Stop, completionHandler: @escaping (Result<[Tram]>) -> Void) {
        self.completionHandler = completionHandler

        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.query = "&operator=LUAS&stopid=\(stop.id)"

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
                    _ = try Response.decode(data)
                    let trams: [Tram] = try [Tram].decode(data => "results")
                    self.completionHandler(.success(trams))
                } catch {
                    self.completionHandler(.error(error))
                }

            case .failure(let error):
                self.completionHandler(.error(error))
            }
        }

    }

}
