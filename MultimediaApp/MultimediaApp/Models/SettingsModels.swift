//
//  SettingsModels.swift
//  MultimediaApp
//
//  Created by developer on 29.07.2021.
//

import Foundation
import UIKit

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let image: UIImage?
    let title: String
    let tintColor: UIColor
    let handler: () -> Void
}

