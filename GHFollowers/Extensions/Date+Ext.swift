//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Jeff Morhous on 10/25/20.
//  Copyright © 2020 Jeff Morhous. All rights reserved.
//

import Foundation

extension Date {
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
