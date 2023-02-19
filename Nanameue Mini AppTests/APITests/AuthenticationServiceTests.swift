//
//  AuthenticationServiceTests.swift
//  Nanameue Mini AppTests
//
//  Created by Shahid on 2023-02-18.
//

import XCTest
import FirebaseFirestore
@testable import Nanameue_Mini_App

final class AuthenticationServiceTests: XCTestCase {
    
    func testLogin() {
        
        let exp = self.expectation(description: "Waiting for async operation to finish - exp 1")
        let exp2 = self.expectation(description: "Waiting for async operation to finish - exp 2")
        
        // Test Login with proper/correct email and password
        var email = "asna@gmail.com"
        var password = "password"
        AuthenticationService.loginUser(withEmail: email, password: password) { result, error in
            let expectedResult = email
            let actualResult = result?.user.email
            XCTAssertEqual(actualResult, expectedResult)
            
            exp.fulfill()
        }
        
        
        // Test Login with incorrect email and password
        email = "asna@gmail.com"
        password = "password111"
        AuthenticationService.loginUser(withEmail: email, password: password) { result, error in
            if let error = error {
                XCTAssertNotNil(error)
                exp2.fulfill()
            }
        }
        
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSignUp() {
        
        let exp = self.expectation(description: "Waiting for async operation to finish - exp 1")
        let exp2 = self.expectation(description: "Waiting for async operation to finish - exp 2")
        let exp3 = self.expectation(description: "Waiting for async operation to finish - exp 3")
        
        //Random fake email and Random passwords are used only for testing purpose
        var data = AuthData(email: randomFakeEmail(), password: randomFakePassword(), name: "Test User", username: "test.user", profile: UIImage(named: "profile_placeholder")!)
        var expectedResult = true
        
        // Test Sign up with correct auth credentials
        XCTContext.runActivity(named: "Proper working sign up") { _ in
            AuthenticationService.signupUser(withData: data) { error, actualResult in
                XCTAssertEqual(actualResult, expectedResult)
                exp.fulfill()
            }
        }
        
        
//        // Test Sign up with incorrect auth credentials  - incorrectEmail
        var data2 = AuthData(email: "incorrectEmail", password: "Password@123", name: "Test User", username: "test.user2", profile: UIImage(named: "profile_placeholder")!)
        var expectedResult2 = false

        XCTContext.runActivity(named: "Sign up with incorrect email") { _ in
            AuthenticationService.signupUser(withData: data2) { error, actualResult in
                if let error = error {
                    XCTAssertEqual(actualResult, expectedResult2)
                    XCTAssertNotNil(error)
                    exp2.fulfill()
                }
            }
        }
        

//        // Test Sign up with existing email/user
        var data3 = AuthData(email: "shahid@gmail.com", password: "password", name: "Test User", username: "test.user3", profile: UIImage(named: "profile_placeholder")!)
        var expectedResult3 = false

        XCTContext.runActivity(named: "Sign up with existing user email") { _ in
            AuthenticationService.signupUser(withData: data3) { error, actualResult in
                if let error = error {
                    XCTAssertEqual(actualResult, expectedResult3)
                    XCTAssertNotNil(error)
                    exp3.fulfill()
                }
            }
        }
        
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    func randomFakeEmail() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomString = String((0..<9).map{ _ in letters.randomElement()! })
        let randomEmail = "\(randomString)@yopmail.com"
        return randomEmail
    }
    
    func randomFakePassword() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomString = String((0..<9).map{ _ in letters.randomElement()! })
        return randomString
    }
    
}
