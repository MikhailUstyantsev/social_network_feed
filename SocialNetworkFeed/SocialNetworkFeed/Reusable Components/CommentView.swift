//
//  CommentView.swift
//  SocialNetworkFeed
//
//  Created by Mikhail Ustyantsev on 08.03.2025.
//

import UIKit

class CommentView: UIView {
    
    // MARK: - Subviews
    
    private let commenterImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 35
        return iv
    }()
    
    private let commenterNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let commenterTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 79/255, green: 115/255, blue: 150/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let commentTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 79/255, green: 115/255, blue: 150/255, alpha: 1)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializer
    
    /// Initialize the comment view with all required data.
    /// - Parameters:
    ///   - image: The commenter's image.
    ///   - name: The commenter's name.
    ///   - time: The time stamp of the comment.
    ///   - comment: The comment text.
    init(image: UIImage?, name: String, time: String, comment: String) {
        super.init(frame: .zero)
        setupView()
        configure(image: image, name: name, time: time, comment: comment)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Setup
    
    private func setupView() {
        let labelsStack = UIStackView(arrangedSubviews: [commenterNameLabel, commenterTimeLabel, commentTextLabel])
        labelsStack.axis = .vertical
        labelsStack.spacing = 4
        labelsStack.translatesAutoresizingMaskIntoConstraints = false
        
        let containerStack = UIStackView(arrangedSubviews: [commenterImageView, labelsStack])
        containerStack.axis = .horizontal
        containerStack.spacing = 12
        containerStack.alignment = .top
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerStack)
        
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: topAnchor),
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            commenterImageView.widthAnchor.constraint(equalToConstant: 70),
            commenterImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    // MARK: - Configuration
    
    private func configure(image: UIImage?, name: String, time: String, comment: String) {
        commenterImageView.image = image
        commenterNameLabel.text = name
        commenterTimeLabel.text = time
        commentTextLabel.text = comment
    }
}

