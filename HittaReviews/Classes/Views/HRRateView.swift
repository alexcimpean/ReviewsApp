//
//  HRRateView.swift
//  HittaReviews
//
//  Created by Alexandru Cimpean on 17/07/2018.
//  Copyright © 2018 Alexandru Cimpean. All rights reserved.
//

import UIKit

protocol HRRateViewDelegate {
    
    func userDidRate(_ value: Double)
}


class HRRateView: UIView {
    
    var delegate: HRRateViewDelegate?
    
    var score: Double = 0 {
        didSet {
            if oldValue != score {
                updateRating()
            }
        }
    }
    
    var userCanEdit: Bool = true {
        didSet {
            self.isUserInteractionEnabled = self.userCanEdit
        }
    }
    
    var starSpacing = 17 {
        didSet {
            stackView.spacing = CGFloat(starSpacing)
        }
    }
    
    private var starViews: Array<UIImageView> = []
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var star_1: UIImageView!
    @IBOutlet private weak var star_2: UIImageView!
    @IBOutlet private weak var star_3: UIImageView!
    @IBOutlet private weak var star_4: UIImageView!
    @IBOutlet private weak var star_5: UIImageView!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        
        Bundle.main.loadNibNamed("HRRateView", owner: self, options: nil)
        addSubview(contentView)
        
        contentView.frame = self.bounds
        setupComponents()
    }
    
    private func setupComponents() {
        
        starViews.append(star_1)
        starViews.append(star_2)
        starViews.append(star_3)
        starViews.append(star_4)
        starViews.append(star_5)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        contentView.addGestureRecognizer(tapGR)
        
        updateRating()
    }
    
    private func updateRating() {
        
        for i in 0..<starViews.count {
            let imageView = starViews[i]
            let imageName = (Double(i) + 1 <= score) ? "star_filled" : "star_empty"
            imageView.image = UIImage(named: imageName)
        }
    }
    
    @objc private func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        
        if gestureRecognizer.state == .ended {
            let touchLocation = gestureRecognizer.location(in: self)
            score = Double((touchLocation.x * 5)/contentView.frame.width) + 1
            
            if delegate != nil {
                delegate!.userDidRate(score)
            }
        }
    }
    
    deinit {
        self.delegate = nil
    }
}
