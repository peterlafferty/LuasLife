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

    func testGetRoutesRequest() {
        let expectation = expectationWithDescription("GetRoutesRequest")

        GetRoutesRequest { (result) -> Void in
            let error:ErrorType?
            let routes:[Route]?
            
            switch result {
            case .Error(let e):
                error = e
                routes = nil
            case .Success(let r):
                error = nil
                routes = r
            }
            
            XCTAssertNil(error)
            XCTAssertNotNil(routes, "an array of routes should be returned")
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(10){ error in
            XCTAssertNil(error)
        }
    
    }
    
}
