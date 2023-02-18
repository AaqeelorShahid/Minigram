//
//  MinigramAppTests.swift
//  MinigramAppTests AppTests
//
//  Created by Shahid on 2023-02-18.
//

import XCTest
@testable import Nanameue_Mini_App

class MinigramAppTests: XCTestCase {
    
    var sut: LoginViewModel!

    override func setUpWithError() throws {
        sut = LoginViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testLogin() {
        // given
        let email = "shahidaaqeel@gmail.com"
        let password = "Iwbase@20"
        
        sut.email = email
        sut.password = password
        
        // when
        let result = sut.isValid
        
        // then
        XCTAssertEqual(result, true)
    }
    
    func testRegistration() {
        
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
