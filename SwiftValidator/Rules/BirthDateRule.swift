//
//  BirthRule.swift
//  SwiftValidator
//
//  Created by Stas Telnov on 04/07/2019.
//  Copyright © 2019 jpotts18. All rights reserved.
//

import Foundation

/// Seconds in 1 day.
private let kSecondsInDay: TimeInterval =  24 * 3_600

/// Seconds in 100 years. Years * days in one year * hours in one day * seconds in one day
private let kTimeInterval100Years: TimeInterval = 100 * 365 * kSecondsInDay

/**
 `BirthDateRule` is a subclass of `Rule` that check and validate birth date with format, locale, min and max dates
 */
public class BirthDateRule: Rule {
    /// Error message to be displayed if validation fails.
    private var message: String
    
    /// Date format of `DateFormatter`. Default is dd.MM.yyyy
    private var dateFormat: String
    /// Locale identifier of `Locale`. Default is current locale identifier
    private var localeIdentifier: String
    
    /// Maximum date of birth. Default is current day
    private var maxDate: Date
    /// Minimal date of birth. Default current date minus 100 years
    private var minDate: Date = Date(timeIntervalSinceNow: -kTimeInterval100Years) // hack, because in validate method optional date never not nil
    
    /// If true, that result string of `DateFormatter` should equal to value
    private var isValueEqualToFormat: Bool
    
    /**
     Initializes a `BirthDateRule` object to validate that the text of a field is a birth date.
     
     - parameter message: String of error message.
     - parameter format: Date format string of `DateFormatter`.
     - parameter localeIdentifier: Identifier string of `Locale`.
     - parameter maxDate: Maximum date of birth.
     - parameter minDate: Minimal date of birth. Optional.
     - parameter isValueEqualToFormat: Minimal date of birth. Optional.
     - returns: An initialized object, or nil if an object could not be created for some reason that would not result in an exception.
     */
    public init(message: String = "Birth date is invalid",
                format: String = "dd.MM.yyyy",
                localeIdentifier: String = Locale.current.identifier,
                maxDate: Date = Date(),
                minDate: Date? = nil,
                isValueEqualToFormat: Bool = true) {
        self.message = message
        self.dateFormat = format
        self.localeIdentifier = localeIdentifier
        self.maxDate = maxDate
        if let minDate = minDate {
            self.minDate = minDate
        }
        
        self.isValueEqualToFormat = isValueEqualToFormat
    }
    
    
    /**
     Used to validate field.
     
     - parameter value: String to checked for validation.
     - returns: Boolean value. True if validation is successful; False if validation fails.
     */
    public func validate(_ value: String) -> Bool {
        guard value.count > 0 else {
            return true
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: localeIdentifier)
        formatter.dateFormat = dateFormat
        guard let date = formatter.date(from: value) else {
            return false
        }
        
        if isValueEqualToFormat,
            value != formatter.string(from: date) {
            return false
        }
        
        
        guard date <= maxDate else {
            return false
        }
        
        guard date >= minDate else {
            return false
        }
        
        return true
    }
    
    
    /**
     Displays an error message when text field fails validation.
     
     - returns: String of error message.
     */
    public func errorMessage() -> String {
        return message
    }
    
}
