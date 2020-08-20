//
//  PomeloPickUpTests.swift
//  PomeloPickUpTests
//
//  Created by Nilesh on 20/8/2563 BE.
//  Copyright © 2563 Nilesh. All rights reserved.
//

import XCTest

@testable import PomeloPickUp

class PomeloPickUpTests: XCTestCase {
    var sut: LocationPresenter!
    var spy: LocationViewDelegateSpy!

    override func setUp() {
        spy = LocationViewDelegateSpy()
        sut = LocationPresenter(locationService: LocationServiceSuccessMock())
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func test_successCase() {
        let exp = expectation(description: "Loading Service.")
        sut.setViewDelegate(trafficLightViewDelegate: spy)
        sut.fetchLocations()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 0.5) { (error) in
            XCTAssert(self.spy.isDisplayAllLocation, "Show All location success.")
        }
    }
}

class LocationServiceSuccessMock: LocationService {
    override func getAllLocation(completion: @escaping LocationService.Completion<LocationInfoModel>) {
        if let model = Bundle.createModelFileJson(fileName: "response_success") {
            completion(.success(object: model))
        } else {
            completion(.failure(error: "Shit"))
        }
    }
}

class LocationViewDelegateSpy: NSObject, LocationViewDelegate {
    var isDisplayAllLocation: Bool = false
    var isFailedToFetchLocation: Bool = false
    
    func displayAllLocation(response: LocationInfoModel) {
        isDisplayAllLocation = true
    }
    func failedToFetchLocation(errorMessage: String) {
        isFailedToFetchLocation = true
    }
}
