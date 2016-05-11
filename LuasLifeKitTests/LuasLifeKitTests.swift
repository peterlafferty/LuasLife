//
//  LuasLifeKitTests.swift
//  LuasLifeKitTests
//
//  Created by Peter Lafferty on 29/02/2016.
//  Copyright © 2016 Peter Lafferty. All rights reserved.
//

import XCTest
@testable import LuasLifeKit

class LuasLifeKitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testGetLinesRequest() {
        let expectation = expectationWithDescription("GetLinesRequest")

        let request = GetLinesRequest { (result) -> Void in
            let error:ErrorType?
            let line:[Line]?
            
            switch result {
            case .Error(let e):
                error = e
                line = nil
            case .Success(let r):
                error = nil
                line = r
            }
            
            XCTAssertNil(error)
            XCTAssertNotNil(line, "an array of lines should be returned")
            expectation.fulfill()
        }

        request.start()
        
        waitForExpectationsWithTimeout(10){ error in
            XCTAssertNil(error)
        }
    
    }

    func testGetStopsForRouteRequest() {
        let expectation = expectationWithDescription("GetStopsForRouteRequest")
        
        let line = Line(type: "LUAS", name: "GREEN")
        
        let request = GetRoutesRequest(line: line) { (result) -> Void in
            let error:ErrorType?
            let routes:[Route]?

            if case let .Error(e) = result {
                error = e
            } else {
                error = nil
            }

            if case let .Success(r) = result {
                routes = r
            } else {
                routes = nil
            }
            
            XCTAssertNil(error)
            XCTAssertNotNil(routes, "an array of routes should be returned")
            expectation.fulfill()
        }
        
        request.start()
        
        waitForExpectationsWithTimeout(10){ error in
            XCTAssertNil(error)
        }
        
    }
    
    func testRealtimeInfoRequest() {
        let expectation = expectationWithDescription("GetRealtimeInfoRequest")
        
        let stop = Stop(id:"LUAS37", name: "Central Park")
        
        let request = GetRealtimeInfoRequest(stop: stop, completionHandler: { (result) -> Void in
            let error:ErrorType?
            let trams:[Tram]?
            
            switch result {
            case .Error(let e):
                error = e
                trams = nil
            case .Success(let r):
                error = nil
                trams = r
            }
          
            XCTAssertNil(error)
            XCTAssertNotNil(trams, "an array of trams should be returned")

            expectation.fulfill()
        })
        
        request.start()
        
        waitForExpectationsWithTimeout(10){ error in
            XCTAssertNil(error)
        }
        
    }
    
}
