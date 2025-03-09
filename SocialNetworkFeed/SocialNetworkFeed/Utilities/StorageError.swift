//
//  StorageError.swift
//  SocialNetworkFeed
//
//  Created by Mikhail Ustyantsev on 07.03.2025.
//

import Foundation

enum StorageError: String, Error {
    case savingError = "Failed to save data to persistent storage."
    case deletingError = "Failed to delete object from persistent storage."
    case retrieveError = "There was a problem loading your data from persistent storage."
}
