//
//  Constants.swift
//  AstonishingDragonWorld
//
//  Created by Stanislav on 14.02.2024.
//

import UIKit

final class Constants {

    static let defaultFontName: String = "pixeleum-48"
    static let defaultFontColor: UIColor = UIColor.white
    static let defaultBackgroundColor: UIColor = UIColor.cyan
    static let defaultBorderColor = UIColor.white.cgColor
    
    static let zeroPoint: CGFloat = 0
    
    static let backButton = "< BACK"
    
    enum fontSize {
        static let fontSize128: CGFloat = 128
        static let fontSize36: CGFloat = 36
        static let fontSize32: CGFloat = 32
        static let fontSize28: CGFloat = 28
        static let fontSize24: CGFloat = 24
        static let fontSize20: CGFloat = 20
        static let fontSize18: CGFloat = 18
        static let fontSize12: CGFloat = 12
    }
    
    enum offsetSize {
        static let offsetSize10: CGFloat = 10
        static let offsetSize16: CGFloat = 16
        static let offsetSize30: CGFloat = 30
        static let offsetSize56: CGFloat = 56
        static let offsetSize64: CGFloat = 64
        static let offsetSize104: CGFloat = 104
    }
    
    enum animationSettings {
        static let defaultWithDuration = 0.3
        static let defaultDelay = 0.0
    }  
}

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}
