//
//  HRCompanyReviewsViewController.swift
//  HittaReviews
//
//  Created by Alexandru Cimpean on 16/07/2018.
//  Copyright © 2018 Alexandru Cimpean. All rights reserved.
//

import UIKit

class HRCompanyReviewsViewController: UIViewController, HRRateViewDelegate, HRViewController, HRRatingsCollectionViewDataControllerDelegate {
    
    var reviewsService: HRReviewsService?
    var user: HRUser? {
        get {
            if reviewsService != nil {
                return reviewsService!.currentUser()
            }
            
            return nil
        }
    }
    
    var company: HRCompany? {
        didSet {
            self.scoreLabel.text = String(format: "%.1f", company!.score)
            self.noOfRatingsLabel.text = "from \(String(company!.noOfReviews)) ratings"
        }
    }
    
    var page = 1
    var userScore: Double = 0
    var editableReview: HRReview?
    var rateView: HRRateHeaderView?
    var reviewsCollectionDataController = HRRatingsCollectionViewDataController()
    
    
    @IBOutlet weak var viewAllReviewsButton: UIButton!
    @IBOutlet weak var reviewsCollectionView: UICollectionView!
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var noOfRatingsLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        userScore = 0
       
        configureCollectionView()
        updateRateView()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            
        case kShowUserRatingSegue:
            if let modalNavigationVC = segue.destination as? UINavigationController,
                let userRatingVC = modalNavigationVC.topViewController as? HRUserRatingViewController {
                
                userRatingVC.reviewsService = reviewsService
                userRatingVC.review = editableReview
                userRatingVC.userScore = userScore
                userRatingVC.company = company
            }
            
        default:
            return
        }
    }
    
    private func updateRateView() {
        
        if didUserRateTheCompany() == false {
            if rateView == nil {
                let newRateView = HRRateHeaderView()
                newRateView.delegate = self
                newRateView.heightAnchor.constraint(equalToConstant: kRateHeaderHeight).isActive = true
                contentStackView.insertArrangedSubview(newRateView, at: 1)
                rateView = newRateView
            }
            
            rateView?.score = userScore
        }
        else {
            if rateView != nil {
                contentStackView.removeArrangedSubview(rateView!)
                rateView!.removeFromSuperview()
                rateView = nil
            }
        }
    }
    
    private func configureCollectionView() {
        
        reviewsCollectionView.delegate = reviewsCollectionDataController
        reviewsCollectionView.dataSource = reviewsCollectionDataController
        
        reviewsCollectionView.register(HRReviewCell.classForCoder(), forCellWithReuseIdentifier: kRatingsReusableCellIdentifier)
        reviewsCollectionView.register(UINib(nibName: "HRReviewCell", bundle: Bundle.main), forCellWithReuseIdentifier: kRatingsReusableCellIdentifier)
        reviewsCollectionView.register(UICollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        
        reviewsCollectionDataController.delegate = self
        
        if let service = self.reviewsService {
            reviewsCollectionDataController.reviews = service.allReviews(forCompany: company, page: page)
            verifyReviewsDisplayed()
        }
        
        reviewsCollectionView.reloadData()
    }
    
    func verifyReviewsDisplayed() {
        
        if let reviewsNo = company?.noOfReviews,
            reviewsCollectionDataController.reviews.count >= reviewsNo {
            viewAllReviewsButton.isEnabled = false
            return
        }
        
        viewAllReviewsButton.isEnabled = true
    }
    
    @IBAction func viewAllReviewsTapped(_ sender: Any) {
        
        page += 1
        
        if let service = self.reviewsService {
            reviewsCollectionDataController.reviews = service.allReviews(forCompany: company, page: page)
            reviewsCollectionView.reloadData()
        }
        
        verifyReviewsDisplayed()
    }
    
    // MARK: - HRRateViewDelegate
    
    func userDidRate(_ value: Double) {
        
        userScore = floor(value)
        self.performSegue(withIdentifier: kShowUserRatingSegue, sender: self)
    }
    
    // MARK: - HRRatingsCollectionViewDataControllerDelegate
    
    func didUserRateTheCompany() -> Bool {
        
        if let service = self.reviewsService {
            return service.didUserRateCompany(user: user, company: company)
        }
        
        return false
    }
    
    func userWillEdit(_ rating: HRReview) {
        
        editableReview = rating
        self.performSegue(withIdentifier: kShowUserRatingSegue, sender: self)
    }
    
    func getCollectionView() -> UICollectionView {
        
        return reviewsCollectionView
    }
}

