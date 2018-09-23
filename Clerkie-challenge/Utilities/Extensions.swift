//
//  File.swift
//  Clerkie-challenge
//
//  Created by Antonio Chan on 2018/9/19.
//  Copyright © 2018 Antonio Chan. All rights reserved.
//

import UIKit
import Lottie

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
        
        struct Red {
            static let PastelRed = UIColor(hexString: "#ff6961")
        }
        
        struct Orange {
            static let PastelOrange = UIColor(hexString: "#ffb347")
        }
        
        struct Purple {
            static let PastelPurple = UIColor(hexString: "#b19cd9")
        }
    }
}

extension String {
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
}

extension UIViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.35)
        
        let animationView = LOTAnimationView(name: "Loader")
        animationView.frame = CGRect(x:0, y: 0, width:60, height:60)
        animationView.center = spinnerView.center
        animationView.loopAnimation = true
        animationView.contentMode = .scaleAspectFill
        
        animationView.play()
        
        DispatchQueue.main.async {
            spinnerView.addSubview(animationView)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}

extension UIImageView{
    
    func setImageFromURl(stringImageUrl url: String){
        
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                self.image = UIImage(data: data as Data)
            }
        }
    }
}

@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
