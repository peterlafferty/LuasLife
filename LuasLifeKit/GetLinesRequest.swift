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

public struct URLs {
    fileprivate static let bundleIdentifier = "com.peterlafferty.LuasLifeKit"
    public static var getLines = URL(string: "http://localhost/index.php/lines")!
    public static var getRoutes = URL(string: "http://localhost/index.php/routes?line-id=1")!
    //public static var getRoutes = "https://data.dublinked.ie/cgi-bin/rtpi/routeinformation?format=json&operator=LUAS&routeid=RED" // swiftlint:disable:this line_length
    public static var getStops = URL(string: "http://localhost/index.php/stops?route-id=1")!
    public static var getRealTimeInfo = "https://data.dublinked.ie/cgi-bin/rtpi/realtimebusinformation?stopid=LUAS21&routeid=RED&maxresults=100&operator=Luas" // swiftlint:disable:this line_length
}

/// This struct represents the lines on the Luas.
public struct GetLinesRequest {
    let url: URL
    let completionHandler: (Result<[Line]>) -> Void
    /**
        Initialises the request with the url and completion handler
        - parameter url: the url to use
        - parameter completionHandler: a closure to call when the request
        has completed

        The current routes are:
        - Green
        - Red

    */
    public init(url: URL = URLs.getLines, completionHandler: @escaping (Result<[Line]>) -> Void) {
        self.url = url
        self.completionHandler = completionHandler
    }

    public func start() {
        Alamofire.request(url).responseJSON { (response) -> Void in
            switch response.result {
            case .success(let data):

                do {
                    let lines = try [Line].decode(data => "results")

                    self.completionHandler(.success(lines))
                } catch {
                    self.completionHandler(.error(error))
                }

            case .failure(let error):
                self.completionHandler(.error(error))
            }
        }
    }

}
