//
//  ArticleTableViewCell.swift
//  SocialNetworkFeed
//
//  Created by Mikhail Ustyantsev on 06.03.2025.
//

import UIKit
import Alamofire

class ArticleTableViewCell: UITableViewCell {
    
    var onBookmarkTapped: (() -> Void)?
    var state = false
    private let imageCache = NSCache<NSString, UIImage>()
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
    
    // Bookmark button
    private let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "bookmark"), for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Stack view for user info (username & GitHub username)
    private lazy var userInfoStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [usernameLabel, githubUsernameLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        return stack
    }()
    
    // Container stack view for header: user info and bookmark button.
    private lazy var headerStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [userInfoStackView, bookmarkButton])
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // Stack view for reaction views
    private lazy var reactionsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [positiveReactionView, commentReactionView, publicReactionView])
        stack.distribution = .fillEqually
        stack.spacing = 16
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
        contentView.addSubview(headerStackView)
        contentView.addSubview(articleTitleLabel)
        contentView.addSubview(reactionsStackView)
        
        contentView.backgroundColor = .secondarySystemBackground
        
        bookmarkButton.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            // Avatar Image View
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            
            // Header Stack View (user info and bookmark)
            headerStackView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            headerStackView.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            headerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Constrain bookmark button (optional)
            bookmarkButton.widthAnchor.constraint(equalToConstant: 24),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 24),
            
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
    
    // MARK: - Actions
    
    @objc private func bookmarkButtonTapped() {
        state = !state
        updateBookmarkState(isBookmarked: state, animated: true)
        onBookmarkTapped?()
    }
    
    func updateBookmarkState(isBookmarked: Bool, animated: Bool) {
        bookmarkButton.setImage(isBookmarked ? UIImage(named: "bookmark.filled") : UIImage(named: "bookmark"), for: .normal)
        
        if animated {
            if let bookmarkImageView = bookmarkButton.imageView {
                bookmarkImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                UIView.animate(withDuration: 0.3,
                               delay: 0,
                               usingSpringWithDamping: 0.5,
                               initialSpringVelocity: 3,
                               options: .allowUserInteraction,
                               animations: {
                    bookmarkImageView.transform = .identity
                }, completion: nil)
            }
        }
    }

    
    // MARK: - Configuration
    
    func configure(with article: Article) {
        state = article.isBookmarked
       
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
        
        bookmarkButton.setImage(article.isBookmarked ? UIImage(named: "bookmark.filled") : UIImage(named: "bookmark"), for: .normal)
        
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
