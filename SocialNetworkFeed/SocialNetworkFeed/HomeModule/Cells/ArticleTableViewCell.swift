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
            // Set a fixed size (e.g. 40x40) and make it round
            iv.layer.cornerRadius = 20
            return iv
        }()
        
        private let usernameLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        private let githubUsernameLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = .gray
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        // Article title label
        private let articleTitleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 18)
            label.numberOfLines = 0 // Allow multiline titles
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        // Reaction items: image + count label for each reaction
        private let positiveReactionImageView: UIImageView = {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFit
            iv.translatesAutoresizingMaskIntoConstraints = false
            return iv
        }()
        
        private let positiveReactionLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        private let commentImageView: UIImageView = {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFit
            iv.translatesAutoresizingMaskIntoConstraints = false
            return iv
        }()
        
        private let commentLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        private let publicReactionImageView: UIImageView = {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFit
            iv.translatesAutoresizingMaskIntoConstraints = false
            return iv
        }()
        
        private let publicReactionLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        // Stack views to organize the layout
        private lazy var userInfoStackView: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [usernameLabel, githubUsernameLabel])
            stack.axis = .vertical
            stack.spacing = 4
            stack.alignment = .leading
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        
        private lazy var positiveReactionStack: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [positiveReactionImageView, positiveReactionLabel])
            stack.spacing = 4
            return stack
        }()
        
        private lazy var commentStack: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [commentImageView, commentLabel])
            stack.spacing = 4
            return stack
        }()
        
        private lazy var publicReactionStack: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [publicReactionImageView, publicReactionLabel])
            stack.spacing = 4
            return stack
        }()
        
        private lazy var reactionsStackView: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [positiveReactionStack, commentStack, publicReactionStack])
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
                avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
                avatarImageView.widthAnchor.constraint(equalToConstant: 40),
                avatarImageView.heightAnchor.constraint(equalToConstant: 40),
                
                userInfoStackView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
                userInfoStackView.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
                userInfoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                
             
                articleTitleLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
                articleTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                articleTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                
                reactionsStackView.topAnchor.constraint(equalTo: articleTitleLabel.bottomAnchor, constant: 12),
                reactionsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                reactionsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                reactionsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
            ])
            
            // Optionally, set fixed dimensions for reaction images (e.g., 16x16)
            [positiveReactionImageView, commentImageView, publicReactionImageView].forEach { imageView in
                NSLayoutConstraint.activate([
                    imageView.widthAnchor.constraint(equalToConstant: 16),
                    imageView.heightAnchor.constraint(equalToConstant: 16)
                ])
            }
        }
        
        // MARK: - Configuration
        
        /// Configures the cell with an Article model.
        func configure(with article: Article) {
            if let imageUrlString = article.user?.profileImage90,
               let url = URL(string: imageUrlString) {
                AF.request(url).validate().responseData { response in
                    if let data = response.data {
                        self.avatarImageView.image = UIImage(data: data)
                    }
                }
            } else {
                avatarImageView.image = nil
            }
            
            // Set user info labels
            usernameLabel.text = article.user?.name
            githubUsernameLabel.text = "GitHub: \(article.user?.githubUsername ?? "not set")"
            
            articleTitleLabel.text = article.title
            
            positiveReactionLabel.text = "\(article.positiveReactionsCount ?? 0)"
            commentLabel.text = "\(article.commentsCount ?? 0)"
            publicReactionLabel.text = "\(article.publicReactionsCount ?? 0)"
            
            positiveReactionImageView.image = UIImage(named: "positive")
            commentImageView.image = UIImage(named: "comments")
            publicReactionImageView.image = UIImage(named: "public_reactions")
        }

}
