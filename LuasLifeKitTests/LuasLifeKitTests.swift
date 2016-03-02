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

        GetLinesRequest { (result) -> Void in
            let error:ErrorType?
            let routes:[Line]?
            
            switch result {
            case .Error(let e):
                error = e
                routes = nil
            case .Success(let r):
                error = nil
                routes = r
            }
            
            XCTAssertNil(error)
            XCTAssertNotNil(routes, "an array of lines should be returned")
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(10){ error in
            XCTAssertNil(error)
        }
    
    }

    func testGetStopsForRouteRequest() {
        let expectation = expectationWithDescription("GetStopsForRouteRequest")

        GetRoutesRequest { (result) -> Void in
            if case .Success(let routes) = result {
                print(routes)
            } else if case .Error(let error) = result {
                print(error)
            }
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10){ error in
            XCTAssertNil(error)
        }
        
    }
    
    
}
