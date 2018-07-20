//
//  HRReviewCell.swift
//  HittaReviews
//
//  Created by Alexandru Cimpean on 19/07/2018.
//  Copyright © 2018 Alexandru Cimpean. All rights reserved.
//

import UIKit

protocol HRReviewCellDelegate {
    
    func userWillEdit(_ cell: HRReviewCell)
}

class HRReviewCell: UICollectionViewCell {
    
    var delegate: HRReviewCellDelegate?
    
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var rateView: HRRateView!
    @IBOutlet private weak var subtitleLabel: UILabel!
    private var tapGR: UITapGestureRecognizer?

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        rateView.userCanEdit = false
        rateView.starSpacing = 0
        rateView.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionTextView.textContainerInset = .zero
        descriptionTextView.contentInset = UIEdgeInsetsMake(0, -5, 0, 0)
    }
    
    func setDescriptionText(_ text: String, highlighted: Bool) {
        
        descriptionTextView.textColor = UIColor.black
        descriptionTextView.text = text
        
        removeTapGR()
        
        if highlighted {
            descriptionTextView.textColor = UIColor(fromHex: kHighlightedTextColour)
            updateTapGR()
        }
    }
    
    func setImage(_ image: UIImage) {
        
        imageView.image = image
    }
    
    func setRating(_ score: Double) {
        
        rateView.score = score
    }
    
    func setName(_ name: String) {
        
        userNameLabel.text = name
    }
    
    func setTimeAndWebsite(time: String, website: String) {
        
        subtitleLabel.text = "\(time) - \(website)"
    }
    
    private func updateTapGR() {
        
        if tapGR == nil {
            
            tapGR = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            self.contentView.addGestureRecognizer(tapGR!)
        }
    }
    
    private func removeTapGR() {
        
        if tapGR != nil {
            
            self.contentView.removeGestureRecognizer(tapGR!)
            tapGR = nil
        }
    }
    
    @objc private func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        
        if gestureRecognizer.state == .ended {
            
            if delegate != nil {
                delegate!.userWillEdit(self)
            }
        }
    }
}
