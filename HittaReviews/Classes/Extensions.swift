//
//  Extensions.swift
//  HittaReviews
//
//  Created by Alexandru Cimpean on 16/07/2018.
//  Copyright © 2018 Alexandru Cimpean. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    
    static func hoursPassed(previousDate: Date) -> DateComponents {
        
        let calendar: Calendar = Calendar.current
        return calendar.dateComponents([.hour, .day], from: previousDate, to: Date())
    }
}

extension Data {
    
    func dictionaryFromJSON () -> Dictionary<String, Any>? {
        
        do {
            if let dict = try JSONSerialization.jsonObject(with: self, options: .allowFragments)
                as? Dictionary<String, Any> {
                return dict
            }
        }
        catch let error {
            print("Failed to load: \(error.localizedDescription)")
        }
        
        return nil
    }
}

extension String {
    
    static func timePassedFromDateComponents(_ dateComponents: DateComponents) -> String {
        
        var amountOfTime = ""
        if let day = dateComponents.day, day > 0 {
            amountOfTime = "\(day)d"
        }
        else if let hour = dateComponents.hour, hour > 0 {
            amountOfTime = "\(hour)h"
        }
        else {
            amountOfTime = "less than 1h"
        }
        
        return "\(amountOfTime) ago"
    }
}

extension UIColor {
    
    convenience public init(fromHex hex: Int) {
        
        self.init(red: (CGFloat)((hex & 0xFF0000) >> 16)/255.0,
                  green: (CGFloat)((hex & 0x00FF00) >>  8)/255.0,
                  blue: (CGFloat)((hex & 0x0000FF) >>  0)/255.0,
                  alpha: 1.0)
    }
}

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
