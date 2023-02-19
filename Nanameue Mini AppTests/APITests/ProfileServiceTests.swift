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
        let exp2 = self.expectation(description: "Waiting for async operation to finish - exp 2")
        
        // Test whether profile picture getting updated in the DB
        let expectedResult = false
        ProfileService.updateProfilePicture(image: UIImage(named: "profile")!) { result, error in
            XCTAssertEqual(result.isEmpty, expectedResult)
            exp.fulfill()
        }
        
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    

}
