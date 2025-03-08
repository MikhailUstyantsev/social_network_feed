//
//  Date + Ext.swift
//  SocialNetworkFeed
//
//  Created by Mikhail Ustyantsev on 08.03.2025.
//

import Foundation

extension Date {
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
    /// Creates a Date from an ISO8601 formatted string.
    /// - Parameter iso8601String: A string in ISO8601 format (e.g., "2025-03-07T14:23:38Z")
    /// - Returns: A Date if the string is valid; otherwise, nil.
    static func fromISO8601(_ iso8601String: String) -> Date? {
        let isoFormatter = ISO8601DateFormatter()
        return isoFormatter.date(from: iso8601String)
    }
}
