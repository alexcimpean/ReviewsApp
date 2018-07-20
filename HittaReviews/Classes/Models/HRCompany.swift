//
//  HRCompany.swift
//  HittaReviews
//
//  Created by Alexandru Cimpean on 16/07/2018.
//  Copyright © 2018 Alexandru Cimpean. All rights reserved.
//

import Foundation

class HRCompany: NSObject {
    
    private(set) var id: String?
    var name: String?
    var score: Double
    var noOfReviews: Int
    
    init(fromDictionary dictionary: Dictionary<String, Any>) {
        
        self.id = dictionary["id"] as? String
        self.name = dictionary["displayName"] as? String
        
        if let score = dictionary["score"] as? Double {
            self.score = score
        }
        else if let score = dictionary["score"] as? Int {
            self.score = Double(score)
        }
        else {
            self.score = 0
        }
        
        self.noOfReviews = 0
    }
}
