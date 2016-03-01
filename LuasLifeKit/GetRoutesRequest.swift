//
//  GetRoutesRequest.swift
//  LuasLife
//
//  Created by Peter Lafferty on 29/02/2016.
//  Copyright © 2016 Peter Lafferty. All rights reserved.
//

import Foundation


import Foundation
import Alamofire
import Decodable

// TODO: move this in to it's own file
public struct URLs {
    public static var routeListURL = "https://data.dublinked.ie/cgi-bin/rtpi/routelistinformation?format=json&operator=LUAS"
}


/// This struct represents the routes on the Luas.
public struct GetRoutesRequest {
    /**
        Initialises the request with the url and completion handler
        - parameter url: the url to use
        - parameter completionHandler: a closure to call when the request 
        has completed
        
        The current routes are:
        - Green
        - Red

    */
    public init(url:NSURL = NSURL(string: URLs.routeListURL)!, completionHandler: Result<[Route]> -> Void) {
        
        Alamofire.request(.GET, url).responseJSON { (response) -> Void in
            switch response.result {
            case .Success(let data):
                
                do {
                    _ = try Response.decode(data)
                    let routes = try [Route].decode(data => "results")
                    
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