//
//  String+Extension.swift
//  MultimediaApp
//
//  Created by developer on 05.08.2021.
//

import Foundation

extension String {
    
    static func formattedDate(string: String) -> String {
        if let date = DateFormatter.dateFormatter.date(from: string) {
            return DateFormatter.displayDateFormatter.string(from: date)
        }
        return string
    }
    
}
