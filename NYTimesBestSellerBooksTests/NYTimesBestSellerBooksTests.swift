//
//  NYTimesBestSellerBooksTests.swift
//  NYTimesBestSellerBooksTests
//
//  Created by C4Q on 5/7/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import XCTest
@testable import NYTimesBestSellerBooks

class NYTimesBestSellerBooksTests: XCTestCase {
    
    var resData: Data? = nil
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGoogleBooksAPI() {
        //XCTestExpectation is for testing asynchronous calls/network requests
       let booksResultsExpectation = XCTestExpectation(description: "Books results received")
       //start network request
        if let url = URL(string: "https://api.nytimes.com/svc/books/v3/lists.json?api-key=44b75ac0d27a44b5a98c2919a81ffa76&list=Combined%20Print%20and%20E-Book%20Fiction") {
            NetworkHelper.manager.performDataTask(with: url, completionHandler: { (data) in
                self.resData = data
            }) { (error) in
                print(error)
            }
        }
        
        let pred = NSPredicate(format: "resData != nil")
        let exp = expectation(for: pred, evaluatedWith: self, handler: nil)
        let res = XCTWaiter.wait(for: [exp], timeout: 3.0)
        if res == XCTWaiter.Result.completed {
            XCTAssertNotNil(resData, "No data received from the server for infoView Content")
        } else {
            XCTAssert(false, "The call to get URL ran into some other error")
        }
    }
    
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
