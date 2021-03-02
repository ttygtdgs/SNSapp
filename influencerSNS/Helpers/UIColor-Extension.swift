//
//  UIColor-Extension.swift
//  influencerSNS
//
//  Created by user on 2021/03/01.
//

//rgbで色指定するのを簡単にするextension
import UIKit

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return self.init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
