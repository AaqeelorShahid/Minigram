//
//  AuthenticationModelTests.swift
//  AuthenticationModelTests
//
//  Created by Shahid on 2023-02-18.
//

import XCTest
@testable import Nanameue_Mini_App

class AuthenticationModelTests: XCTestCase {
    
    var loginModel: LoginViewModel!
    var registrationModel: RegistationViewModel!

    override func setUpWithError() throws {
        loginModel = LoginViewModel()
        registrationModel = RegistationViewModel()
    }

    override func tearDownWithError() throws {
        loginModel = nil
        registrationModel = nil
    }
    
    func testLogin() {
        
        //Proper login
        var email = "shahidaaqeel@gmail.com"
        var password = "Iwbase@20"
        
        loginModel = LoginViewModel(email: email, password: password)
        XCTContext.runActivity(named: "Successful Login") { _ in
            let expectedResult = true
            let actualResult = loginModel.isValid
            XCTAssertEqual(actualResult, expectedResult)
        }
        
        // Test login with incorrect email - Doesn't contain "@"
        
        loginModel = LoginViewModel(email: "shahidaaqeelgmail.com", password: "Iwbase@20")
        XCTContext.runActivity(named: "Incorrect email") { _ in
            let expectedResult = false
            let actualResult = loginModel.isValid
            XCTAssertEqual(actualResult, expectedResult)
        }
        
        
        // Test login with incorrect password - less than 8 characters
        
        loginModel = LoginViewModel(email: "shahidaaqeel@gmail.com", password: "Pass@1")
        XCTContext.runActivity(named: "Incorrect password - less than 8 characters") { _ in
            let expectedResult = false
            let actualResult = loginModel.isValid
            XCTAssertEqual(actualResult, expectedResult)
        }
        
        // Test login with incorrect password - doesn't contain special character
        
        loginModel = LoginViewModel(email: "shahidaaqeel@gmail.com", password: "Password2")
        XCTContext.runActivity(named: "Incorrect password - doesn't contain special character") { _ in
            let expectedResult = false
            let actualResult = loginModel.isValid
            XCTAssertEqual(actualResult, expectedResult)
        }
        
        // Test login with incorrect password - doesn't contain at least one uppercase

        loginModel = LoginViewModel(email: "shahidaaqeel@gmail.com", password: "password2")
        XCTContext.runActivity(named: "Incorrect password - doesn't contain at least one uppercase") { _ in
            let expectedResult = false
            let actualResult = loginModel.isValid
            XCTAssertEqual(actualResult, expectedResult)
        }
        
        // Test login with empty email and password
        
        loginModel = LoginViewModel(email: "", password: "")
        XCTContext.runActivity(named: "Incorrect password - doesn't contain at least one uppercase") { _ in
            let expectedResult = false
            let actualResult = loginModel.isValid
            XCTAssertEqual(actualResult, expectedResult)
        }
    }
    
    func testRegistration() {
        
        //Proper Registration
        var name = "Shahid"
        var email = "shahidaaqeel@gmail.com"
        var password = "Password@12"
        var username = "shahid.aaqeel"
        
        registrationModel = RegistationViewModel(email:email, password: password, name: name, username: username)
        XCTContext.runActivity(named: "Successful Registration") { _ in
            let expectedResult = true
            let actualResult = registrationModel.isValid
        }
        
        // Test sign up with incorrect email - Doesn't contain "@"
        registrationModel = RegistationViewModel(email:"Shahid",
                                                 password: "shahidaaqeelgmail.com",
                                                 name: "Password@12",
                                                 username: "shahid.aaqeel")
        
        XCTContext.runActivity(named: "Incorrect email - white space") { _ in
            let expectedResult = false
            let actualResult = registrationModel.isValid
            XCTAssertEqual(actualResult, expectedResult)
        }
        
        // Test sign up with incorrect email - Doesn't contain "@"
        registrationModel = RegistationViewModel(email:"Shahid",
                                                 password: "shahidaaqeelgmail.com",
                                                 name: "Password@12",
                                                 username: "shahid.aaqeel")
        
        XCTContext.runActivity(named: "Incorrect email - white space") { _ in
            let expectedResult = false
            let actualResult = registrationModel.isValid
            XCTAssertEqual(actualResult, expectedResult)
        }
        
        // Test sign up with incorrect email - Doesn't contain "@"
        registrationModel = RegistationViewModel(email:"Shahid",
                                                 password: "shahidaaqeelgmail.com",
                                                 name: "Password@12",
                                                 username: "shahid.aaqeel")
        
        XCTContext.runActivity(named: "Incorrect email - white space") { _ in
            let expectedResult = false
            let actualResult = registrationModel.isValid
            XCTAssertEqual(actualResult, expectedResult)
        }
        
        // Test sign up with incorrect email - Does contain whitespace
        registrationModel = RegistationViewModel(email:"Shahid",
                                                 password: "shahid aaqeel@gmail.com",
                                                 name: "Password@12",
                                                 username: "shahid.aaqeel")
        
        XCTContext.runActivity(named: "Incorrect email - white space") { _ in
            let expectedResult = false
            let actualResult = registrationModel.isValid
            XCTAssertEqual(actualResult, expectedResult)
        }
        
        // Test sign up with incorrect password - Does contain whitespace
        registrationModel = RegistationViewModel(email:"Shahid",
                                                 password: "shahidaaqeel@gmail.com",
                                                 name: "Password 12@",
                                                 username: "shahid.aaqeel")
        
        XCTContext.runActivity(named: "Incorrect password - white space") { _ in
            let expectedResult = false
            let actualResult = registrationModel.isValid
            XCTAssertEqual(actualResult, expectedResult)
        }
        
        // Test sign up with incorrect password - Does'nt contain special character
        registrationModel = RegistationViewModel(email:"Shahid",
                                                 password: "shahidaaqeel@gmail.com",
                                                 name: "Password12",
                                                 username: "shahid.aaqeel")
        
        XCTContext.runActivity(named: "Incorrect password - does'n contain special character") { _ in
            let expectedResult = false
            let actualResult = registrationModel.isValid
            XCTAssertEqual(actualResult, expectedResult)
        }
        
        // Test sign up with incorrect password - Does'nt contain at least number
        registrationModel = RegistationViewModel(email:"Shahid",
                                                 password: "shahidaaqeel@gmail.com",
                                                 name: "Password@",
                                                 username: "shahid.aaqeel")
        
        XCTContext.runActivity(named: "Incorrect password - does'nt contain at least one number") { _ in
            let expectedResult = false
            let actualResult = registrationModel.isValid
            XCTAssertEqual(actualResult, expectedResult)
        }
        
        // Test sign up with incorrect username - Does contain whitespace
        registrationModel = RegistationViewModel(email:"Shahid",
                                                 password: "shahidaaqeel@gmail.com",
                                                 name: "Password12",
                                                 username: "shahid aaqeel")
        
        XCTContext.runActivity(named: "Incorrect username - white space") { _ in
            let expectedResult = false
            let actualResult = registrationModel.isValid
            XCTAssertEqual(actualResult, expectedResult)
        }
        
        // Test sign up with empty name
        registrationModel = RegistationViewModel(email:"",
                                                 password: "shahidaaqeel@gmail.com",
                                                 name: "Password12",
                                                 username: "shahid aaqeel")
        
        XCTContext.runActivity(named: "Incorrect username - white space") { _ in
            let expectedResult = false
            let actualResult = registrationModel.isValid
            XCTAssertEqual(actualResult, expectedResult)
        }
    }

}
