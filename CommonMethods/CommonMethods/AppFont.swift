//
//  AppFont.swift
//  Storead
//
//  Created by Bhavesh Chaudhari on 09/10/19.
//  Copyright © 2019 Bhavesh Chaudhari. All rights reserved.
//

import Foundation
import UIKit

/// The object represent Fonts used in entire Application.
enum FontBook: String {
    case sfProDisplayRegular = "SFProDisplay-Regular"
    case sfProDisplayMedium = "SFProDisplay-Medium"
    case sfProDisplayBold = "SFProDisplay-Bold"
    func of(size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
}

extension UIFontDescriptor.AttributeName {

    /// object used to get UIFont usage Attribute.it is used with Font  object to replace Custom font with system Font
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

extension UIFont {

    /// class function replace regular custom font with regular system font
    /// - Parameter size: size of Font
    @objc class func mySystemFont(ofSize size: CGFloat) -> UIFont {
        return FontBook.sfProDisplayRegular.of(size: size)
    }

    /// class function replace Bold custom font with Bold system font
    /// - Parameter size: size of Font
    @objc class func myBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        return FontBook.sfProDisplayBold.of(size: size)
    }

    /// class function replace Italic custom font with Italic system font
    /// - Parameter size: size of Font
    @objc class func myItalicSystemFont(ofSize size: CGFloat) -> UIFont {
        return FontBook.sfProDisplayMedium.of(size: size)
    }

    /// class function replace medium custom font with medium system font
    /// - Parameter size: size of Font
    @objc class func myMediumSystemFont(ofSize size: CGFloat) -> UIFont {
        return FontBook.sfProDisplayMedium.of(size: size)
    }

    /// constructor used for initialise Font.
    /// - Parameter aDecoder: NSCoder object to decode Font.
    @objc convenience init(myCoder aDecoder: NSCoder) {
        guard
            let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor,
            let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String else {
                self.init(myCoder: aDecoder)
                return
        }
        var fontName = ""
        switch fontAttribute {
        case "CTFontRegularUsage":
            fontName = FontBook.sfProDisplayRegular.rawValue
        case "CTFontEmphasizedUsage", "CTFontBoldUsage":
            fontName = FontBook.sfProDisplayBold.rawValue
        case "CTFontObliqueUsage":
            fontName = FontBook.sfProDisplayBold.rawValue
        default:
            fontName = FontBook.sfProDisplayMedium.rawValue
        }
        let size = fontDescriptor.pointSize
//        let preciseConstant = (size * UIScreen.main.bounds.size.height)  / 736
//        let  newSize = preciseConstant > size ? size : preciseConstant
        self.init(name: fontName, size: size)!
    }

    /// class function that perform method swizzling for UIFont methods.
    class func overrideInitialize() {
        guard self == UIFont.self else { return }

        if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:))),
            let mySystemFontMethod = class_getClassMethod(self, #selector(mySystemFont(ofSize:))) {
            method_exchangeImplementations(systemFontMethod, mySystemFontMethod)
        }

        if let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:))),
            let myBoldSystemFontMethod = class_getClassMethod(self, #selector(myBoldSystemFont(ofSize:))) {
            method_exchangeImplementations(boldSystemFontMethod, myBoldSystemFontMethod)
        }

        if let italicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:))),
            let myItalicSystemFontMethod = class_getClassMethod(self, #selector(myItalicSystemFont(ofSize:))) {
            method_exchangeImplementations(italicSystemFontMethod, myItalicSystemFontMethod)
        }

        if let midiemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:weight:))),
            let mymediuemSystemFontMethod = class_getClassMethod(self, #selector(myMediumSystemFont(ofSize:))) {
            method_exchangeImplementations(midiemFontMethod, mymediuemSystemFontMethod)
        }

        if let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))), // Trick to get over the lack of UIFont.init(coder:))
            let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:))) {
            method_exchangeImplementations(initCoderMethod, myInitCoderMethod)
        }
    }
}
