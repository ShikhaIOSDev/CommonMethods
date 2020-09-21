//
//  Extension+UIButton.swift
//
//  Created by TechnoMac6 on 26/02/20.
//  Copyright © 2020 TechnoMac6. All rights reserved.
//

import UIKit

extension UIView
{
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    @IBInspectable var borderColorCg: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable open var shadowRadius: CGFloat{
        get{
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    /// Color of the badge shadow
    @IBInspectable open var shadowColor: UIColor {
        //        didSet {
        //            layer.shadowColor = shadowColor.cgColor
        //            setNeedsDisplay()
        //        }
        get{
            return UIColor(cgColor: layer.shadowColor!)
        }
        set{
            layer.shadowColor = newValue.cgColor
            setNeedsDisplay()
            
        }
    }
    
    @IBInspectable open var shadowOpacity: CGFloat {
        
        get{
            return CGFloat(layer.shadowOpacity)
        }
        set{
            layer.shadowOpacity = Float(newValue)
            
        }
    }
    
    @IBInspectable var shadowOffset: CGPoint {
        set {
            layer.shadowOffset = CGSize(width: newValue.x, height: newValue.y)
        }
        get {
            return CGPoint(x: layer.shadowOffset.width, y:layer.shadowOffset.height)
        }
    }
}
extension UIView{
    func dropShadowToView(cornerRadius:CGFloat,shadowRadius:CGFloat,shadowOpacity:Float){
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
    }
}

extension UIView {

    func applyShadowWithCornerRadius(color:UIColor, opacity:Float, radius: CGFloat, edge:AIEdge, shadowSpace:CGFloat)    {

        var sizeOffset:CGSize = CGSize.zero
        switch edge {
        case .Top:
            sizeOffset = CGSize(width: 0, height: -shadowSpace)
        case .Left:
            sizeOffset = CGSize(width: -shadowSpace, height: 0)
        case .Bottom:
            sizeOffset = CGSize(width: 0, height: shadowSpace)
        case .Right:
            sizeOffset = CGSize(width: shadowSpace, height: 0)


        case .Top_Left:
            sizeOffset = CGSize(width: -shadowSpace, height: -shadowSpace)
        case .Top_Right:
            sizeOffset = CGSize(width: shadowSpace, height: -shadowSpace)
        case .Bottom_Left:
            sizeOffset = CGSize(width: -shadowSpace, height: shadowSpace)
        case .Bottom_Right:
            sizeOffset = CGSize(width: shadowSpace, height: shadowSpace)


        case .All:
            sizeOffset = CGSize(width: 0, height: 0)
        case .None:
            sizeOffset = CGSize.zero
        }

        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true;

        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = sizeOffset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false

        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.layer.cornerRadius).cgPath
    }
}

enum AIEdge:Int {
    case
    Top,
    Left,
    Bottom,
    Right,
    Top_Left,
    Top_Right,
    Bottom_Left,
    Bottom_Right,
    All,
    None
}

extension UIView{
    func dropShadow(cornerRadius:CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = cornerRadius
        self.layer.masksToBounds = false
    }
}
extension UIView{
    func bounceEffect(duration:TimeInterval){
            UIView.animate(withDuration: duration, animations: {
                self.transform = .init(scaleX: 0.97, y: 0.97)
            }) { (success) in
                if success{
                    UIView.animate(withDuration: duration) {
                    self.transform = .identity
                    }
                }
            }
    }
}

extension UIView{
    func bounceEffectOnceBIG(duration:TimeInterval){
            UIView.animate(withDuration: duration, animations: {
                self.transform = .init(scaleX: 1.16, y: 1.16)
            }) { (success) in
                if success{
                    UIView.animate(withDuration: duration) {
                    self.transform = .identity
                    }
                }
            }
    }
}

extension UIView{
    func bounceEffectColorQuiz(duration:TimeInterval){
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.1, options: [[.autoreverse,.repeat,.beginFromCurrentState,.allowUserInteraction]], animations: {
            self.transform = .init(scaleX: 1.16, y: 1.16)
        }) { (success) in
            if success{
                UIView.animate(withDuration: duration) {
                    self.transform = .identity
                    self.layoutIfNeeded()
                }
            }
        }
    }
}


extension UIView{
    
    func setViewApperance(cornerRadius:CGFloat, borderSize: CGFloat, color: UIColor){
        self.cornerRadius = cornerRadius
        self.borderWidth = borderSize
        self.borderColorCg = color
        self.clipsToBounds = true
    }
}


extension String {
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}

extension UINavigationController {

    func backToViewController(viewController: Swift.AnyClass) {

            for element in viewControllers as Array {
                if element.isKind(of: viewController) {
                    self.popToViewController(element, animated: true)
                break
            }
        }
    }
}


extension Date {

  func isEqualTo(_ date: Date) -> Bool {
    return self == date
  }
  
  func isGreaterThan(_ date: Date) -> Bool {
     return self > date
  }
  
  func isSmallerThan(_ date: Date) -> Bool {
     return self < date
  }
}

extension Int {

  func isEqualTo(_ number: Int) -> Bool {
    return self == number
  }
  
  func isGreaterThan(_ number: Int) -> Bool {
     return self > number
  }
  
  func isSmallerThan(_ number: Int) -> Bool {
     return self < number
  }
}
