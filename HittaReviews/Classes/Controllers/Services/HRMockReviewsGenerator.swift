//
//  HRMockReviewsGenerator.swift
//  HittaReviews
//
//  Created by Alexandru Cimpean on 19/07/2018.
//  Copyright © 2018 Alexandru Cimpean. All rights reserved.
//

import Foundation

struct HRMockReviewsGenerator {
    
    static func mockRewviews(page: Int) -> [HRReview] {
        
        var mocks = [] as Array<HRReview>
        
        let user = HRUser(name: "happy56", noOfReviews: 0, pictureURL: nil, pictureNameFromDisk: "mock_girl")
        var review1 = HRReview(score: 4, user: nil, ownerName: nil, description: "Liked it very much - probably one of the best thai restaurants in the city - recommend!")
        review1.date = Date(timeIntervalSinceNow: -43200)
        var review2 = HRReview(score: 3, user: nil, ownerName: "Jenny Svensson", description: "Maybe a bit too fast food. I personally dislike that. Good otherwise.!")
        review2.date = Date(timeIntervalSinceNow: -86400)
        var review3 = HRReview(score: 5, user: user, ownerName: nil, description: "Super good! Love the food!")
        review3.date = Date(timeIntervalSinceNow: -90000)
        
        mocks.append(review1)
        mocks.append(review2)
        mocks.append(review3)
        
        if page > 1 {
            let review21 = HRReview(score: 5, user: nil, ownerName: "Jon Snow", description: "Winter is Coming!")
            mocks.append(review21)
        }
        
        return mocks
    }
    
    static func mockCompanyStats() -> (score: Double, numberOfReviews: Int) {
        
        return (4.2, 4)
    }
}
