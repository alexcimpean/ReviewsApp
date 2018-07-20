//
//  HRReviewsService.swift
//  HittaReviews
//
//  Created by Alexandru Cimpean on 19/07/2018.
//  Copyright © 2018 Alexandru Cimpean. All rights reserved.
//

import Foundation

class HRReviewsService: NSObject {
    
    private var userReviews: Dictionary<String, HRReview> = [:]
    private var user: HRUser?
    private var networkManager: HRNetworkManager = HRNetworkManager()
    
    func currentUser() -> HRUser {
        
        if user == nil {
            user = HRUser(name: nil, noOfReviews: 0, pictureURL: nil, pictureNameFromDisk: nil)
        }
        
        return user!
    }
    
    func getCompany(completion: @escaping (_ company: HRCompany) -> Void) {
        
        networkManager.getCompanyData { (rawData) in
            if let dictRoot = rawData?.dictionaryFromJSON() {
                let dictValue = dictRoot["result"] as! Dictionary<String, Any>
                let allCompanyData = dictValue["companies"] as! Dictionary<String, Any>
                let companyArray = allCompanyData["company"] as! Array<Any>
                let companyDict = companyArray[0] as! Dictionary<String, Any>
                
                let company = HRCompany(fromDictionary: companyDict)
                
                let mockStats = HRMockReviewsGenerator.mockCompanyStats()
                company.score = mockStats.score
                company.noOfReviews = mockStats.numberOfReviews
                
                completion(company)
            }
        }
    }
    
    func didUserRateCompany(user: HRUser?, company: HRCompany?) -> Bool {
        
        if user == nil || company == nil {
            return false
        }
        else if let companyId = company?.id {
            let review = userReviews[companyId]
            return (review != nil)
        }
        
        return false
    }
    
    func allReviews(forCompany company: HRCompany?, page: Int) -> [HRReview] {
        
        var reviews = HRMockReviewsGenerator.mockRewviews(page: page)
        
        if let companyId = company?.id, let review = userReviews[companyId] {
            reviews.insert(review, at: 0)
        }
        
        return reviews
    }
    
    func saveReview(for review: HRReview, company: inout HRCompany, user: HRUser, completion: @escaping (_ complete: Bool) -> Void) {
        
        if self.user == nil {
            self.user = user
        }
        
        if let companyId = company.id {
            userReviews[companyId] = review
            self.user!.noOfReviews += 1
            company.noOfReviews += 1
            
            if self.user!.name == nil, let ownerName = review.ownerName {
                self.user!.name = ownerName
            }
            
            let jsonData = postJSON(for: review, company: company, user: user)
            networkManager.saveReview(jsonData) { (complete) in
                completion(complete)
            }
        }
        else {
            completion(false)
        }
    }
    
    func postJSON(for review: HRReview, company: HRCompany, user: HRUser) -> Data {
        
        var dictionaryForPost: Dictionary<String, Any> = [:]
        dictionaryForPost["score"] = review.score
        dictionaryForPost["companyId"] = (company.id ?? "ctyfiintu")
        dictionaryForPost["comment"] = (review.description ?? "")
        dictionaryForPost["userName"] = (review.ownerName ?? "Anonymous")
        
        let jsonData = try! JSONSerialization.data(withJSONObject: dictionaryForPost, options: [])
        
        return jsonData
    }
}
