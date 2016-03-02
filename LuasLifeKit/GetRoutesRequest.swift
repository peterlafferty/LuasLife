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
    public init(url:NSURL = NSURL(string: URLs.getRoutes)!, completionHandler: Result<[Route]> -> Void) {
        
        Alamofire.request(.GET, url).responseJSON { (response) -> Void in
            switch response.result {
            case .Success(let data):
                
                do {
                    _ = try Response.decode(data)
                    
                    let routes:[Route] = try [Route].decode(data => "results")

                    
                    completionHandler(.Success(routes))
                } catch {
                    completionHandler(.Error(error))
                }
                
            case .Failure(let error):
                completionHandler(.Error(error))
            }
        }
        
        
    }
    
    
}