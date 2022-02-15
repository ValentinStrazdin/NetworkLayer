//
//  Date+Extension.swift
//  NetworkLayer
//
//  Created by Valentin Strazdin on 2/15/22.
//

import Foundation

extension Date {

    var displayString: String {
        let dateFormatter = DateFormatter(customDateFormat: .displayDate)
        return dateFormatter.string(from: self)
    }
}
