//
//  UIColor+Extension.swift
//  MultimediaApp
//
//  Created by Игорь Пенкин on 01.05.2021.
//

import Foundation
import UIKit

extension UIColor {
    
    open class var mainColors: [UIColor] {
        return [ .spotifyGreen, .yellow, .blue, .brown, .link, .cyan, .green, .lightGray, .magenta, .orange, .purple, .red]
    }
    
    open class var spotifyGreen: UIColor {
        return UIColor(red: 36/255, green: 178/255, blue: 78/255, alpha: 1.0)
    }
    
}
