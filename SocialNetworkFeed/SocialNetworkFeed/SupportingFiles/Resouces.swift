//
//  R.swift
//  SocialNetworkFeed
//
//  Created by Mikhail Ustyantsev on 06.03.2025.
//

import UIKit

enum R {
    
    enum String {
        static let homeVCtitle = "Feed"
    }
    
    enum Font {
        
        static func helveticaRegular(with size: CGFloat) -> UIFont {
            UIFont(name: "Helvetica", size: size) ?? UIFont()
        }
        
        static func montserratRegular(with size: CGFloat) -> UIFont {
            UIFont(name: "Montserrat-Regular", size: size) ?? UIFont()
        }
        
        static func montserratMedium(with size: CGFloat) -> UIFont {
            UIFont(name: "Montserrat-Medium", size: size) ?? UIFont()
        }
        
        static func montserratSemiBold(with size: CGFloat) -> UIFont {
            UIFont(name: "Montserrat-SemiBold", size: size) ?? UIFont()
        }
        
        static func montserratLight(with size: CGFloat) -> UIFont {
            UIFont(name: "Montserrat-Light", size: size) ?? UIFont()
        }
    }
    
    
}
