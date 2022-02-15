//
//  DateFormatter+CustomDateFormat.swift
//  NetworkLayer
//
//  Created by Valentin Strazdin on 2/14/22.
//

import Foundation

public enum CustomDateFormat: String {
    case apiDate = "MM/dd/yyyy"
    case displayDate = "MMM dd, yyyy"
}

extension DateFormatter {

    convenience init(customDateFormat: CustomDateFormat) {
        self.init()
        self.locale = Locale(identifier: "en_US_POSIX")
        self.dateFormat = customDateFormat.rawValue
    }
}
