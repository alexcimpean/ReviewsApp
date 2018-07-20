//
//  HRUser.swift
//  HittaReviews
//
//  Created by Alexandru Cimpean on 16/07/2018.
//  Copyright © 2018 Alexandru Cimpean. All rights reserved.
//

import Foundation

struct HRUser {
    
    let id = NSUUID().uuidString
    var name: String?
    var noOfReviews = 0
    var pictureURL: String?
    var pictureNameFromDisk: String?
}
