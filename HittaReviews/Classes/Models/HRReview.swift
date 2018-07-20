//
//  HRReview.swift
//  HittaReviews
//
//  Created by Alexandru Cimpean on 16/07/2018.
//  Copyright © 2018 Alexandru Cimpean. All rights reserved.
//

import Foundation

struct HRReview {
    
    let id = NSUUID().uuidString
    var user: HRUser?
    var score: Double = 0
    var description: String?
    var ownerName: String?
    var date: Date = Date()
    var sourceWebsite: String = "hitta.se"
    
    init(score: Double, user: HRUser?, ownerName: String?, description: String?) {
        
        self.score = score
        self.user = user
        self.ownerName = ownerName
        self.description = description
        
        if ownerName == nil && user != nil {
            if let name = user!.name {
                self.ownerName = name
            }
        }
    }
}
