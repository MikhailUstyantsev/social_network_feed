//
//  ArticleInteractionView.swift
//  SocialNetworkFeed
//
//  Created by Mikhail Ustyantsev on 08.03.2025.
//

import UIKit

class ArticleInteractionView: UIView {
    
    private let commentsCountLabel = UILabel()
    private let likesCountLabel = UILabel()
    private let sharesCountLabel = UILabel()
    
    init(article: Article) {
        super.init(frame: .zero)
        setupInteractionSection(with: article)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private func setupInteractionSection(with article: Article) {
        let interactionStack = UIStackView()
        interactionStack.axis = .horizontal
        interactionStack.alignment = .center
        interactionStack.distribution = .equalSpacing
        interactionStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(interactionStack)
        
        let commentsStack = createIconStack(systemImageName: "message", countLabel: commentsCountLabel, count: article.commentsCount ?? 0)
        interactionStack.addArrangedSubview(commentsStack)
        
        let likesStack = createIconStack(systemImageName: "heart", countLabel: likesCountLabel, count: article.positiveReactionsCount ?? 0)
        interactionStack.addArrangedSubview(likesStack)
        
        let sharesStack = createIconStack(systemImageName: "paperplane", countLabel: sharesCountLabel, count: article.publicReactionsCount ?? 0)
        interactionStack.addArrangedSubview(sharesStack)
        
       
        NSLayoutConstraint.activate([
            interactionStack.topAnchor.constraint(equalTo: topAnchor),
            interactionStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            interactionStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            interactionStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func createIconStack(systemImageName: String, countLabel: UILabel, count: Int) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let iconImageView = UIImageView(image: UIImage(systemName: systemImageName))
        iconImageView.tintColor = .secondaryLabel
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(iconImageView)
        
        // Configure the count label.
        countLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        countLabel.textColor = .secondaryLabel
        countLabel.text = "\(count)"
        stack.addArrangedSubview(countLabel)
        
        return stack
    }
}
