//
//  Int + Ext.swift
//  SocialNetworkFeed
//
//  Created by Mikhail Ustyantsev on 08.03.2025.
//

import Foundation

extension Int {
    func pluralized(singular: String, plural: String? = nil) -> String {
        let pluralForm = plural ?? singular + "s"
        return self == 1 ? singular : pluralForm
    }
}
