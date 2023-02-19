//
//  ProfileServiceTests.swift
//  Nanameue Mini AppTests
//
//  Created by Shahid on 2023-02-19.
//

import XCTest
import FirebaseFirestore
@testable import Nanameue_Mini_App

final class ProfileServiceTests: XCTestCase {
    
    // !!! Please Login into the app before doing this test !!!
    ///     Since It requires user uid - please login

    func testFetchUserData() {
        let exp = self.expectation(description: "Waiting for async operation to finish - exp")
        
        // Test whether api is fetching the user data properly
        let expectedResult = true
        ProfileService.fetchUserData{ data, actualResult in
            XCTAssertEqual(actualResult, expectedResult)
            exp.fulfill()
        }
        
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    func testProfilePictureUpdate() {
        let exp = self.expectation(description: "Waiting for async operation to finish - exp")
        
        // Test whether profile picture getting updated in the DB
        let expectedResult = false
        guard let testProfilePicture = UIImage(named: "test_profile") else {return}
        ProfileService.updateProfilePicture(image: testProfilePicture) { result, error in
            XCTAssertEqual(result.isEmpty, expectedResult)
            exp.fulfill()
        }
        
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    

}
