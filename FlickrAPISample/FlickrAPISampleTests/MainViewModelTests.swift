//
//  MainViewModelTests.swift
//  FlickrAPISampleTests
//
//  Created by Erica Geraldes on 23/07/2019.
//  Copyright © 2019 Erica Geraldes. All rights reserved.
//

import XCTest
@testable import FlickrAPISample
class MainViewModelTests: XCTestCase {
    
    struct NetworkManagerMock: NetworkManagerProtocol {
        func cancelRequest() {
            return
        }
        
        func getImagesWithTags(page: Int, tags: [String], completion: @escaping (ImageResults?, NetworkError?) -> Void) {
            return
        }
        
        func getImageSize(photoId: String, completion: @escaping (Sizes?, NetworkError?) -> Void) {
            return
        }
    }
    
    func testSomething() {
        var viewModel = MainViewModel(networkManager: NetworkManagerMock())
        
    }
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
