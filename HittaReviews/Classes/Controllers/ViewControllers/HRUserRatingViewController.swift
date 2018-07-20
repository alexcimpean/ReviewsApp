//
//  HRUserRatingViewController.swift
//  HittaReviews
//
//  Created by Alexandru Cimpean on 18/07/2018.
//  Copyright © 2018 Alexandru Cimpean. All rights reserved.
//

import UIKit

let kNameTextViewTag = 1001
let kDescriptionTextViewTag = 1002

class HRUserRatingViewController: UIViewController, UITextViewDelegate, HRRateViewDelegate, HRViewController {
   
    var reviewsService: HRReviewsService?
    
    var userScore: Double = 0
    var company: HRCompany?
    var review: HRReview?
    
    @IBOutlet weak var ratingText: UILabel!
    @IBOutlet weak var rateView: HRRateView!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if company != nil, let name = company?.name {
            navigationItem.title = "Review \(name)"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
        let helvetica = UIFont(name: "HelveticaNeue", size: 17.0)!
        
        closeButton.setTitleTextAttributes([NSAttributedStringKey.font : helvetica], for: .normal)
        saveButton.setTitleTextAttributes([NSAttributedStringKey.font : helvetica], for: .normal)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font : helvetica, NSAttributedStringKey.foregroundColor : UIColor.white]
        
        nameTextView.delegate = self
        nameTextView.tag = kNameTextViewTag
        descriptionTextView.delegate = self
        descriptionTextView.tag = kDescriptionTextViewTag
        
        if review != nil, let user = review?.user, let name = user.name {
            nameTextView.text = name
        }
        else {
            nameTextView.text = placeholderForTextView(nameTextView)
        }
        
        descriptionTextView.text = placeholderForTextView(descriptionTextView)
        
        ratingText.text = ""
        if review != nil {
            userScore = review!.score
        }
        
        if rateView != nil {
            
            rateView.delegate = self
            rateView.score = userScore
            updateRatings()
        }
    }
    
    private func updateRatings() {
      
        userScore = floor(rateView.score)
        ratingText.text = NSLocalizedString("rating_text_\(Int(userScore))", comment: "")
    }
    
    @IBAction private func close(_ sender: Any) {
        
        hideKeyboard()
        
        if descriptionTextView.text == placeholderForTextView(descriptionTextView) &&
            nameTextView.text == placeholderForTextView(nameTextView) {
          exit()
        }
        else {
        
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let saveAndExit = UIAlertAction(title: "Exit and save your review", style: .default) { (action) in self.saveAndExit(true) }
            let exitWithoutSaving = UIAlertAction(title: "Exit without saving", style: .destructive) { (action) in self.exit() }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            actionSheet.addAction(saveAndExit)
            actionSheet.addAction(exitWithoutSaving)
            actionSheet.addAction(cancel)
            
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    
    @IBAction private func save(_ sender: Any) {
        
        hideKeyboard()
        saveAndExit(true)
    }
    
    private func saveAndExit(_ withAlert: Bool) {
        
        if !withAlert {
            exit()
            return
        }
        
        if self.reviewsService != nil, company != nil {
            
            var user = self.reviewsService!.currentUser()
            
            var nameInField = nameTextView.text
            if nameTextView.text == placeholderForTextView(nameTextView) {
                nameInField = nil
            }
            
            if user.name == nil, nameInField != nil {
                user.name = nameInField
            }
            
            var descriptionInField = descriptionTextView.text
            if descriptionTextView.text == placeholderForTextView(descriptionTextView) {
                descriptionInField = nil
            }
            
            let review = HRReview(score: userScore, user: user, ownerName: nameInField, description: descriptionInField)
            
            self.reviewsService!.saveReview(for: review, company: &company!, user: user) { (complete) in
                
                // should cater for failure from server side
                if complete {
                    self.showSuccesAlert()
                }
            }
        }
    }
    
    private func showSuccesAlert() {
        
        let thankYouForRating = UIAlertController(title: "Thank you for your review", message: "You're helping others make smarter decisions every day.", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Okay!", style: .default) { (acttion) in self.exit() }
        thankYouForRating.addAction(confirm)
        
        self.present(thankYouForRating, animated: true, completion: nil)
    }
    
    private func exit() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func hideKeyboard() {
        
        nameTextView.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
    }
    
    private func placeholderForTextView(_ textView: UITextView) -> String {
        
        if textView.tag == kNameTextViewTag {
            return NSLocalizedString("placeholder_name", comment: "")
        }
        else {
            return NSLocalizedString("placeholder_description", comment: "")
        }
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == placeholderForTextView(textView) {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == "" {
            textView.text = placeholderForTextView(textView)
            textView.textColor = UIColor(fromHex: kLightTextColour)
        }
        
        textView.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    // MARK: - HRRateViewDelegate
    
    func userDidRate(_ value: Double) {
        updateRatings()
    }
}
