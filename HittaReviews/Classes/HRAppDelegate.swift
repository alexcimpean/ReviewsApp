//
//  HRAppDelegate.swift
//  HittaReviews
//
//  Created by Alexandru Cimpean on 16/07/2018.
//  Copyright © 2018 Alexandru Cimpean. All rights reserved.
//

import UIKit

@UIApplicationMain
class HRAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if let navigationVC = window?.rootViewController as? UINavigationController,
            let companyReviewsVC = navigationVC.topViewController as? HRCompanyReviewsViewController {
            
            let reviewsService = HRReviewsService()
            companyReviewsVC.reviewsService = reviewsService
            
            // this should not be done on the main thread as it might take a while on low connectivity
            // also, the display of the VC should be postponed until the company is fetched
            
            reviewsService.getCompany { (company) in
                companyReviewsVC.company = company
            }
            
            return true
        }
        
        return false
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
 
    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

    }

}

