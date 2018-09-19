//
//  File.swift
//  Clerkie-challenge
//
//  Created by Antonio Chan on 2018/9/19.
//  Copyright © 2018 Antonio Chan. All rights reserved.
//

import UIKit

extension UIFont {
    class func avenirBookFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "Avenir-Book", size: size)!
    }
    class func avenirMediumFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "Avenir-Medium", size: size)!
    }
    class func avenirMediumObliqueFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "Avenir-MediumOblique", size: size)!
    }
    class func avenirNextRegularFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-Regular", size: size)!
    }
    class func avenirNextDemiBoldFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-DemiBold", size: size)!
    }
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

extension UIColor {
    struct FlatColor {
        struct Gray {
            static let WhiteSmoke = UIColor(hexString: "#fbfafc")
        }
        struct Yellow {
            static let PastelYellow = UIColor(hexString: "#fdfd96")
        }
        
        struct Blue {
            static let PastelBlue = UIColor(hexString: "#aec6cf")
        }
    }
}
