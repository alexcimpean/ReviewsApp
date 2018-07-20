//
//  HRRatingsCollectionViewDataController.swift
//  HittaReviews
//
//  Created by Alexandru Cimpean on 19/07/2018.
//  Copyright © 2018 Alexandru Cimpean. All rights reserved.
//

import UIKit

protocol HRRatingsCollectionViewDataControllerDelegate {
    
    func getCollectionView() -> UICollectionView
    func didUserRateTheCompany() -> Bool
    func userWillEdit(_ rating: HRReview)
}


class HRRatingsCollectionViewDataController: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, HRReviewCellDelegate  {
    
    var delegate: HRRatingsCollectionViewDataControllerDelegate?
    var reviews: [HRReview] = []
    var sectionTitles = ["Latest reviews"]
    
    deinit {
        self.delegate = nil
    }
    
    private func shouldHaveTwoSections() -> Bool {
        
        if  delegate != nil,
            delegate!.didUserRateTheCompany() == true {
            return true
        }
        
        return false
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if shouldHaveTwoSections() {
            if sectionTitles.count == 1 {
                sectionTitles.insert("Your review", at: 0)
            }
            
            return 2
        }
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if shouldHaveTwoSections() {
            switch section {
            case 0:
                return 1
            case 1:
                return reviews.count - 1
            default:
                return 0
            }
        }
        
        return reviews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kRatingsReusableCellIdentifier, for: indexPath) as! HRReviewCell
        
        cell.delegate = self
        
        var review = reviews[indexPath.row]
        if indexPath.section > 0 {
            review = reviews[indexPath.row + 1]
        }
        
        var descriptionText = review.description
        var descriptionIsHighighted = false
        
        if review.description == nil {
            descriptionText = "Describe your experience"
            descriptionIsHighighted = true
        }
        
        cell.setDescriptionText(descriptionText!, highlighted: descriptionIsHighighted)
        cell.setRating(review.score)
        cell.setName(review.ownerName ?? "Anonymous")
        
        let timePassed = String.timePassedFromDateComponents(Date.hoursPassed(previousDate: review.date))
        cell.setTimeAndWebsite(time: timePassed, website: review.sourceWebsite)
        
        if let image = UIImage(named: "guest") {
            cell.setImage(image)
        }
        
        if let user = review.user,
            let picName = user.pictureNameFromDisk {
            if let image = UIImage(named: picName) {
                cell.setImage(image)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusablevView = UICollectionReusableView()
        
        if ( kind == UICollectionElementKindSectionHeader) {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
            
            for subview in header.subviews {
                subview.removeFromSuperview()
            }
            
            let label = UILabel(frame: CGRect(x: 14, y: 5, width: collectionView.frame.width - 28, height: kCollectionHeaderHeight))
            label.font = UIFont(name: "Helvetica-Bold", size: 16)
            label.text = sectionTitles[indexPath.section]
            header.addSubview(label)
            
            reusablevView = header
        }
        
        return reusablevView
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: CGFloat(kRatingsCellHeight))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: kCollectionHeaderHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
    }
    
    // MARK: - HRReviewCellDelegate
    
    func userWillEdit(_ cell: HRReviewCell) {
        
        if delegate != nil {
            let collectionView = delegate!.getCollectionView()
            let indexpath = collectionView.indexPath(for: cell)
            if let indexPath = indexpath {
                var review = reviews[indexPath.row]
                if indexPath.section > 0 {
                    review = reviews[indexPath.row + 1]
                }
                
                delegate!.userWillEdit(review)
            }
        }
    }
}
