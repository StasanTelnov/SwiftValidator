//
//  BirthRule.swift
//  SwiftValidator
//
//  Created by Stas Telnov on 04/07/2019.
//  Copyright © 2019 jpotts18. All rights reserved.
//

import Foundation

public class BirthDateRule: Rule {
    private var message = "Birth date is invalid"
    
    private var dateFormat = "dd.MM.yyyy"
    
    private var locale: String = Locale.current.identifier
    
    private var minDate: Date?
    
    private var maxDate = Date()
    
    
    public func validate(_ value: String) -> Bool {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: locale)
        
        guard let date = formatter.date(from: value)?.addingTimeInterval(3_600 * 24) else {
            return false
        }
        
        guard date < maxDate else {
            return false
        }
        
        guard let minDate = minDate,
            date >= minDate else {
            return false
        }
        
        return true
    }
    
    public func errorMessage() -> String {
        return message
    }
    
    
}
