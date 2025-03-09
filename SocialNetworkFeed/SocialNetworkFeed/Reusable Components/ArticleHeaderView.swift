//
//  ArticleHeaderView.swift
//  SocialNetworkFeed
//
//  Created by Mikhail Ustyantsev on 08.03.2025.
//

import UIKit

class ArticleHeaderView: UIView {
    
    private let profileImageView = ImageLoader()
    private let usernameLabel = UILabel()
    private let userInfoLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        setupHeaderSection()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHeaderSection() {
        let headerStack = UIStackView()
        headerStack.axis = .horizontal
        headerStack.spacing = 12
        headerStack.alignment = .center
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(headerStack)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 20 
        headerStack.addArrangedSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        let userInfoStack = UIStackView()
        userInfoStack.axis = .vertical
        userInfoStack.spacing = 4
        userInfoStack.translatesAutoresizingMaskIntoConstraints = false
        
        
        usernameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        usernameLabel.textColor = .label
        userInfoStack.addArrangedSubview(usernameLabel)
        
        
        userInfoLabel.font = UIFont.systemFont(ofSize: 14)
        userInfoLabel.textColor = .secondaryLabel
        userInfoStack.addArrangedSubview(userInfoLabel)
        
        headerStack.addArrangedSubview(userInfoStack)
        
        
        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            headerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headerStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            headerStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    //MARK: - Public methods
    func configure(with article: Article) {
        if let url = URL(string: article.user?.profileImage90 ?? "") {
            profileImageView.loadImageWithUrl(url)
        } else {
            profileImageView.image = UIImage(named: "placeholder")
        }
        usernameLabel.text = article.user?.name
        userInfoLabel.text = article.user?.username
    }
}
