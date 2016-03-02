//
//  GetLinesRequest.swift
//  LuasLife
//
//  Created by Peter Lafferty on 29/02/2016.
//  Copyright © 2016 Peter Lafferty. All rights reserved.
//

import Foundation
import Alamofire
import Decodable

// TODO: move this in to it's own file
public struct URLs {
    public static var getLines = "https://data.dublinked.ie/cgi-bin/rtpi/routelistinformation?format=json&operator=LUAS"
    public static var getRoutes = "https://data.dublinked.ie/cgi-bin/rtpi/routeinformation?format=json&operator=LUAS&routeid=RED"
}


/// This struct represents the lines on the Luas.
public struct GetLinesRequest {
    /**
        Initialises the request with the url and completion handler
        - parameter url: the url to use
        - parameter completionHandler: a closure to call when the request 
        has completed
        
        The current routes are:
        - Green
        - Red

    */
    public init(url:NSURL = NSURL(string: URLs.getLines)!, completionHandler: Result<[Line]> -> Void) {
        
        Alamofire.request(.GET, url).responseJSON { (response) -> Void in
            switch response.result {
            case .Success(let data):
                
                do {
                    _ = try Response.decode(data)
                    let lines = try [Line].decode(data => "results")
                    
                    completionHandler(.Success(lines))
                } catch {
                    completionHandler(.Error(error))
                }
                
            case .Failure(let error):
                completionHandler(.Error(error))
            }
        }
        
        
    }

    
}