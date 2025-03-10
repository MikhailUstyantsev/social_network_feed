//
//  ErrorPresenter.swift
//  SocialNetworkFeed
//
//  Created by Mikhail Ustyantsev on 07.03.2025.
//

import UIKit

enum ErrorPresenter {
  static func showError(message: String, on viewController: UIViewController?, dismissAction: ((UIAlertAction) -> Void)? = nil) {
    weak var weakViewController = viewController
    DispatchQueue.main.async {
      let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "Close", style: .default, handler: dismissAction))
      weakViewController?.present(alertController, animated: true)
    }
  }
}
