//
//  HRRateHeaderView.swift
//  HittaReviews
//
//  Created by Alexandru Cimpean on 17/07/2018.
//  Copyright © 2018 Alexandru Cimpean. All rights reserved.
//

import UIKit

class HRRateHeaderView: UIView {

    var delegate: HRRateViewDelegate? {
        didSet {
            rateView.delegate = delegate
        }
    }
    
    var score: Double = 0 {
        didSet {
            rateView.score = 0
        }
    }
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var rateView: HRRateView!
    @IBOutlet private weak var userImageView: UIImageView!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        
        Bundle.main.loadNibNamed("HRRateHeaderView", owner: self, options: nil)
        addSubview(contentView)
        
        contentView.frame = self.bounds
    }
    
    deinit {
        self.delegate = nil
    }
    
}
