//
//  DateFormatter+Extension.swift
//  MultimediaApp
//
//  Created by developer on 05.08.2021.
//

import Foundation

extension DateFormatter {
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()
    
    static let displayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
}
