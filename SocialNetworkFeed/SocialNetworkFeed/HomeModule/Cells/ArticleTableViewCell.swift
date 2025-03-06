//
//  ArticleTableViewCell.swift
//  SocialNetworkFeed
//
//  Created by Mikhail Ustyantsev on 06.03.2025.
//

import UIKit
import Alamofire

class ArticleTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 30
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = R.Font.montserratMedium(with: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let githubUsernameLabel: UILabel = {
        let label = UILabel()
        label.font = R.Font.montserratMedium(with: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let articleTitleLabel: UILabel = {
        let label = UILabel()
        label.font = R.Font.montserratSemiBold(with: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let positiveReactionView = ReactionView()
    private let commentReactionView = ReactionView()
    private let publicReactionView = ReactionView()
    
    private lazy var userInfoStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [usernameLabel, githubUsernameLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var reactionsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [positiveReactionView, commentReactionView, publicReactionView])
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCellUI()
    }
    
    // MARK: - Setup UI
    
    private func setupCellUI() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(userInfoStackView)
        contentView.addSubview(articleTitleLabel)
        contentView.addSubview(reactionsStackView)
        
        NSLayoutConstraint.activate([
            // Avatar Image View
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            
            // User Info Stack View
            userInfoStackView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            userInfoStackView.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            userInfoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Article Title Label
            articleTitleLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            articleTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            articleTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Reactions Stack View
            reactionsStackView.topAnchor.constraint(equalTo: articleTitleLabel.bottomAnchor, constant: 12),
            reactionsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            reactionsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            reactionsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    // MARK: - Configuration
    
    /// Configures the cell with an Article model.
    func configure(with article: Article) {
        // Load avatar image using Alamofire
        if let imageUrlString = article.user?.profileImage90,
           let url = URL(string: imageUrlString) {
            AF.request(url).validate().responseData { response in
                if let data = response.data {
                    self.avatarImageView.image = UIImage(data: data)
                }
            }
        } else {
            avatarImageView.image = UIImage(named: "placeholder")
        }
        
        // Set user info labels
        usernameLabel.text = article.user?.name
        githubUsernameLabel.text = "GitHub: \(article.user?.githubUsername ?? "not set")"
        
        // Set article title
        articleTitleLabel.text = article.title
        
        // Configure each reaction view 
        positiveReactionView.configure(withImageName: "positive", value: article.positiveReactionsCount ?? 0)
        commentReactionView.configure(withImageName: "comments", value: article.commentsCount ?? 0)
        publicReactionView.configure(withImageName: "public_reactions", value: article.publicReactionsCount ?? 0)
    }
}
