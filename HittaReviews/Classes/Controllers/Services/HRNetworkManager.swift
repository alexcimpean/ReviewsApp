//
//  HRNetworkManager.swift
//  HittaReviews
//
//  Created by Alexandru Cimpean on 20/07/2018.
//  Copyright © 2018 Alexandru Cimpean. All rights reserved.
//

import Foundation

class HRNetworkManager: NSObject {
    
    let companyURL = "https://api.hitta.se/search/v7/app/company/ctyfiintu"
    let postURL = "https://test.hitta.se/reviews/v1/company"
    let defaultSession = URLSession(configuration: .default)
    
    func getCompanyData(completion: @escaping (_ data: Data?) -> Void) {
        
        guard let url = URL(string: companyURL)
            else {
                completion(nil)
                return
        }
        
        let completionHandler = { (data: Data?, response: URLResponse?, error: Error?) in
            
            //usually error handling and data sanity check
            DispatchQueue.main.async {
                completion(data)
            }
        }
        
        let task = defaultSession.dataTask(with: url, completionHandler: completionHandler)
        task.resume()
    }
    
    
    func saveReview(_ review: Data, completion: @escaping (_ complete: Bool) -> Void) {
        
        if let url = URL(string: postURL) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = review
            addHeaders(&request)
            
            let completionHandler = {(data: Data?, response: URLResponse?, error: Error?) -> Void in
                
                //usually error handling and data sanity check
                DispatchQueue.main.async {
                    if data != nil && error == nil {
                        completion(true)
                    }
                    else {
                        completion(false)
                    }
                }
            }
            
            let task = defaultSession.dataTask(with: request, completionHandler: completionHandler)
            task.resume()
        }
        else {
            completion(false)
        }
    }
    
    func addHeaders(_ request: inout URLRequest) {
        
       // var request = requestPointer.pointee
        
        request.setValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("MOBILE_WEB", forHTTPHeaderField: "X-HITTA-DEVICE-NAME")
        request.setValue("15188693697264027", forHTTPHeaderField: "X-HITTA-SHARED-IDENTIFIER")
    }
    
}
