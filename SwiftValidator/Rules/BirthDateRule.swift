//
//  BirthRule.swift
//  SwiftValidator
//
//  Created by Stas Telnov on 04/07/2019.
//  Copyright © 2019 jpotts18. All rights reserved.
//

import Foundation


/**
 `BirthDateRule` is a subclass of `Rule` that check and validate birth date with format, locale, min and max dates
 */
public class BirthDateRule: Rule {
    
    public struct ErrorsMessages {
        var general: String
        var maxDate: String
        var minDate: String
        var format: String
        
        public init(general: String = "Birth date incorrect. Should '%@'", maxDate: String = "Birth date dont can more, that %@", minDate: String = "Birth date dont can less, that %@", format: String = "Incorrect format. You should fill date in format '%@', but current date '%@'") {
            self.general = general
            self.maxDate = maxDate
            self.minDate = minDate
            self.format = format
        }
    }
    
    /// Error message to be displayed if validation fails.
    private var message: String?
    
    /// Error message to be displayed if validation fails.
    private var messages: ErrorsMessages
    
    /// Date format of `DateFormatter`. Default is dd.MM.yyyy
    private var dateFormat: String
    /// Locale identifier of `Locale`. Default is current locale identifier
    private var localeIdentifier: String
    
    /// Maximum date of birth. Default is current day
    private var maxDate: Date
    /// Minimal date of birth. Default current date minus 100 years
    private var minDate: Date? = nil // hack, because in validate method optional date never not nil
    
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
    public init(messages: ErrorsMessages = ErrorsMessages(),
                format: String = "dd.MM.yyyy",
                localeIdentifier: String = Locale.current.identifier,
                maxDate: Date = Date(),
                minDate: Date? = nil,
                isValueEqualToFormat: Bool = true) {
        self.messages = messages
        self.dateFormat = format
        self.localeIdentifier = localeIdentifier
        self.maxDate = maxDate
        self.minDate = minDate
        
        self.isValueEqualToFormat = isValueEqualToFormat
    }
    
    /**
     Update one or mo property of `BirthDateRule`.
     
     - parameter format: Date format string of `DateFormatter`.
     - parameter localeIdentifier: Identifier string of `Locale`.
     - parameter maxDate: Maximum date of birth.
     - parameter minDate: Minimal date of birth.
     - parameter isValueEqualToFormat: Minimal date of birth.
     */
    public func updateRule(format: String? = nil,
                           localeIdentifier: String? = nil,
                           maxDate: Date? = nil,
                           minDate: Date? = nil,
                           isValueEqualToFormat: Bool? = nil) {
        self.dateFormat = format ?? self.dateFormat
        self.localeIdentifier = localeIdentifier ?? self.localeIdentifier
        self.maxDate = maxDate ?? self.maxDate
        self.minDate = minDate ?? self.minDate
        
        self.isValueEqualToFormat = isValueEqualToFormat ?? self.isValueEqualToFormat
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
        
        let formatted = formatter.string(from: date)
        if isValueEqualToFormat,
            value != formatted {
            message = String(format: messages.format, dateFormat, value)
            return false
        }
        
        
        guard date <= maxDate else {
            message = String(format: messages.maxDate, formatter.string(from: maxDate))
            return false
        }

        
        if let minDate = minDate,
            date >= minDate {
            message = String(format: messages.minDate, formatter.string(from: minDate))
            return false
        }
        
        return true
    }
    
    
    /**
     Displays an error message when text field fails validation.
     
     - returns: String of error message.
     */
    public func errorMessage() -> String {
        return message ?? String(format: messages.general, dateFormat)
    }
    
}
