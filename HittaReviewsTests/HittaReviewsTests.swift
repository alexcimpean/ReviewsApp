//
//  HittaReviewsTests.swift
//  HittaReviewsTests
//
//  Created by Alexandru Cimpean on 16/07/2018.
//  Copyright © 2018 Alexandru Cimpean. All rights reserved.
//

import XCTest
@testable import HittaReviews

class HittaReviewsTests: XCTestCase {
    
    let reviewsService: HRReviewsService = HRReviewsService()
    
    override func setUp() {
        
        super.setUp()

    }
    
    override func tearDown() {

        super.tearDown()
    }
    
    
    func testCompany() {
        
        let companyData: Dictionary<String, Any> = ["id" : "melon", "displayName" : "The Melonerie", "score" : 4.2]
        let company = HRCompany(fromDictionary: companyData)
        
        XCTAssert(company.id == "melon")
        XCTAssert(company.name == "The Melonerie")
        XCTAssert(company.score == 4.2)
        XCTAssert(company.noOfReviews == 0)
        
    }
    
    func testServiceCurrentUser() {
        
        let currentUser = reviewsService.currentUser()
        
        XCTAssertNil(currentUser.name)
        XCTAssertNil(currentUser.pictureURL)
        XCTAssertNil(currentUser.pictureNameFromDisk)
    }
    
    func testGetMockReviews() {
        
        let companyData: Dictionary<String, Any> = ["id" : "ctyfiintu"]
        let company = HRCompany(fromDictionary: companyData)
        
        var reviews = reviewsService.allReviews(forCompany: company, page: 1)
        
        XCTAssertNotNil(reviews)
        XCTAssert(reviews.count == 3)
        
        reviews = reviewsService.allReviews(forCompany: company, page: 2)
        
        XCTAssertNotNil(reviews)
        XCTAssert(reviews.count == 4)
        
    }
    
    func testGetCompanyPerformance() {

        self.measure {
            
            let expectation = XCTestExpectation(description: "fetching the company data")
            
            reviewsService.getCompany { (company) in
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 3)
        }
    }
    
}
