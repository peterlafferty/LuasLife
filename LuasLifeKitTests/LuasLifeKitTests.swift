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
        let expectation = self.expectation(description: "GetLinesRequest")

        let request = GetLinesRequest { (result) -> Void in
            let error: Error?
            let line: [Line]?

            switch result {
            case .error(let e):
                error = e
                line = nil
            case .success(let r):
                error = nil
                line = r
            }

            XCTAssertNil(error)
            XCTAssertNotNil(line, "an array of lines should be returned")
            expectation.fulfill()
        }

        request.start()

        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error)
        }

    }

    func testGetLinesWithFixtureRequest() {
        let expectation = self.expectation(description: "GetLinesRequest")
        //let identifier = "com.peterlafferty.LuasLifeKit"

        guard let path = Bundle(for: type(of: self)).path(forResource: "LinesFixture", ofType: "js") else {
            XCTFail("Unable to load fixture")
            return
        }

        let url = URL(fileURLWithPath: path)

        let request = GetLinesRequest(url: url) { (result) -> Void in
            let error: Error?
            let lines: [Line]?

            switch result {
            case .error(let e):
                error = e
                lines = nil
            case .success(let r):
                error = nil
                lines = r
            }

            XCTAssertNil(error)
            XCTAssertNotNil(lines, "an array of lines should be returned")
            expectation.fulfill()
        }

        request.start()

        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error)
        }

    }

    func testGetStopsForRouteRequest() {
        let expectation = self.expectation(description: "GetStopsForRouteRequest")

        let line = Line(id: 1, name: "GREEN")

        let request = GetRoutesRequest(line: line) { (result) -> Void in
            let error: Error?
            let routes: [Route]?

            if case let .error(e) = result {
                error = e
            } else {
                error = nil
            }

            if case let .success(r) = result {
                routes = r
            } else {
                routes = nil
            }

            XCTAssertNil(error)
            XCTAssertNotNil(routes, "an array of routes should be returned")
            expectation.fulfill()
        }

        request.start()

        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error)
        }

    }

    func testRealtimeInfoRequest() {
        let expectation = self.expectation(description: "GetRealtimeInfoRequest")

        let stop = Stop(id:14, name: "Central Park")

        let request = GetRealtimeInfoRequest(stop: stop, completionHandler: { (result) -> Void in
            let error: Error?
            let trams: [Tram]?

            switch result {
            case .error(let e):
                error = e
                trams = nil
            case .success(let r):
                error = nil
                trams = r
            }

            XCTAssertNil(error)
            XCTAssertNotNil(trams, "an array of trams should be returned")

            expectation.fulfill()
        })

        request.start()

        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error)
        }

    }

}
