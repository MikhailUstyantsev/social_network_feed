//
//  ArticleDetailViewController.swift
//  SocialNetworkFeed
//
//  Created by Mikhail Ustyantsev on 08.03.2025.
//

import UIKit

class ArticleDetailViewController: UIViewController {
    
    // MARK: - Properties
    private var article: Article
    
    // Scroll view to support scrolling for long content
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // Header/Profile section
    private let profileImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let userInfoLabel = UILabel()
    
    // Article text and main image
    private let articleTextLabel = UILabel()
    private let articleImageView = ImageLoader()
    
    // Interaction icons (comments, likes, shares)
    private let commentsCountLabel = UILabel()
    private let likesCountLabel = UILabel()
    private let sharesCountLabel = UILabel()
    
    // Comments summary: a button for toggling and a time label
    private let showCommentsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show 3 comments", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let commentTimeLabel = UILabel()
    
    // Wrapper view to contain the comments stack and control its height
    private let commentsContainerWrapper = UIView()
    private var commentsContainerHeightConstraint: NSLayoutConstraint!
    
    // The vertical stack that holds all CommentView instances
    private let commentsContainerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 30
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // Bottom toolbar with a comment input field
    private let commentToolbar = UIView()
    private let commentTextField = UITextField()
    
    // Track whether comments are visible or not.
    private var areCommentsVisible = false
    
    // MARK: - Initializer
    init(article: Article) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable) // if using storyboard, remove this initializer
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        navigationItem.largeTitleDisplayMode = .never
        
        setupScrollView()
        setupHeaderSection()
        setupArticleSection()
        setupInteractionSection()
        setupCommentsSection()
        configureWithArticle()
        setupBottomToolbar()
        dismissKeyboardTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
        selector: #selector(keyboardWillShow(notification:)),
        name: UIResponder.keyboardWillShowNotification, object: nil)
       
        NotificationCenter.default.addObserver(self,
        selector: #selector(keyboardWillHide(notification:)),
        name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        let keyboardHeight = keyboardFrame.height
        UIView.animate(withDuration: animationDuration) {
            self.view.frame.origin.y = -keyboardHeight
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        UIView.animate(withDuration: animationDuration) {
            self.view.frame.origin.y = 0
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    
    private func dismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - Setup Methods
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            // Pin the scrollView to the view edges, leaving space at the bottom for the toolbar.
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            
            // Ensure contentView matches scrollView’s width.
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupBottomToolbar() {
        commentToolbar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(commentToolbar)
        commentToolbar.backgroundColor = UIColor(red: 248/255, green: 250/255, blue: 251/255, alpha: 1)
        
        commentTextField.placeholder = "Write a comment..."
        commentTextField.borderStyle = .roundedRect
        commentTextField.translatesAutoresizingMaskIntoConstraints = false
        commentToolbar.addSubview(commentTextField)
        
        NSLayoutConstraint.activate([
            commentToolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            commentToolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            commentToolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            commentToolbar.heightAnchor.constraint(equalToConstant: 60),
            
            commentTextField.leadingAnchor.constraint(equalTo: commentToolbar.leadingAnchor, constant: 16),
            commentTextField.trailingAnchor.constraint(equalTo: commentToolbar.trailingAnchor, constant: -16),
            commentTextField.centerYAnchor.constraint(equalTo: commentToolbar.centerYAnchor),
            commentTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupHeaderSection() {
        let headerStack = UIStackView()
        headerStack.axis = .horizontal
        headerStack.spacing = 12
        headerStack.alignment = .center
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(headerStack)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 20 // 40x40 image
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
        usernameLabel.textColor = .black
        userInfoStack.addArrangedSubview(usernameLabel)
        
        userInfoLabel.font = UIFont.systemFont(ofSize: 14)
        userInfoLabel.textColor = UIColor(red: 79/255, green: 115/255, blue: 150/255, alpha: 1)
        userInfoStack.addArrangedSubview(userInfoLabel)
        
        headerStack.addArrangedSubview(userInfoStack)
        
        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            headerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupArticleSection() {
        articleTextLabel.numberOfLines = 0
        articleTextLabel.font = UIFont.systemFont(ofSize: 16)
        articleTextLabel.textColor = .black
        articleTextLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(articleTextLabel)
        
        NSLayoutConstraint.activate([
            articleTextLabel.topAnchor.constraint(equalTo: profileImageView.superview!.bottomAnchor, constant: 16),
            articleTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            articleTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        articleImageView.contentMode = .scaleAspectFill
        articleImageView.clipsToBounds = true
        articleImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(articleImageView)
        
        NSLayoutConstraint.activate([
            articleImageView.topAnchor.constraint(equalTo: articleTextLabel.bottomAnchor, constant: 16),
            articleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            articleImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            articleImageView.heightAnchor.constraint(equalTo: articleImageView.widthAnchor, multiplier: 2.0/3.0)
        ])
    }
    
    private func setupInteractionSection() {
        let interactionStack = UIStackView()
        interactionStack.axis = .horizontal
        interactionStack.alignment = .center
        interactionStack.distribution = .equalSpacing
        interactionStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(interactionStack)
        
        let commentsStack = createIconStack(systemImageName: "message", countLabel: commentsCountLabel)
        interactionStack.addArrangedSubview(commentsStack)
        
        let likesStack = createIconStack(systemImageName: "heart", countLabel: likesCountLabel)
        interactionStack.addArrangedSubview(likesStack)
        
        let sharesStack = createIconStack(systemImageName: "paperplane", countLabel: sharesCountLabel)
        interactionStack.addArrangedSubview(sharesStack)
        
        NSLayoutConstraint.activate([
            interactionStack.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: 16),
            interactionStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            interactionStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func createIconStack(systemImageName: String, countLabel: UILabel) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let iconImageView = UIImageView(image: UIImage(systemName: systemImageName))
        iconImageView.tintColor = UIColor(red: 79/255, green: 115/255, blue: 150/255, alpha: 1)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(iconImageView)
        
        countLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        countLabel.textColor = UIColor(red: 79/255, green: 115/255, blue: 150/255, alpha: 1)
        stack.addArrangedSubview(countLabel)
        
        return stack
    }
    
    private func setupCommentsSection() {
        commentsContainerWrapper.clipsToBounds = true
        // Create a horizontal stack containing the toggle button and time label.
        let commentsSummaryStack = UIStackView(arrangedSubviews: [showCommentsButton, commentTimeLabel])
        commentsSummaryStack.axis = .horizontal
        commentsSummaryStack.alignment = .center
        commentsSummaryStack.distribution = .equalSpacing
        commentsSummaryStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(commentsSummaryStack)
        
        // Configure commentTimeLabel.
        commentTimeLabel.font = UIFont.systemFont(ofSize: 14)
        commentTimeLabel.textColor = UIColor(red: 79/255, green: 115/255, blue: 150/255, alpha: 1)
        commentTimeLabel.text = "5d"
        
        NSLayoutConstraint.activate([
            commentsSummaryStack.topAnchor.constraint(equalTo: commentsCountLabel.superview!.superview!.bottomAnchor, constant: 16),
            commentsSummaryStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            commentsSummaryStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        // Add target action to toggle comments visibility.
        showCommentsButton.addTarget(self, action: #selector(toggleCommentsVisibility), for: .touchUpInside)
        
        // Create a wrapper view to hold the comments container.
        commentsContainerWrapper.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(commentsContainerWrapper)
        
        // Add the comments container stack (which holds CommentView instances) into the wrapper.
        commentsContainerStack.translatesAutoresizingMaskIntoConstraints = false
        commentsContainerWrapper.addSubview(commentsContainerStack)
        NSLayoutConstraint.activate([
            commentsContainerStack.topAnchor.constraint(equalTo: commentsContainerWrapper.topAnchor),
            commentsContainerStack.leadingAnchor.constraint(equalTo: commentsContainerWrapper.leadingAnchor),
            commentsContainerStack.trailingAnchor.constraint(equalTo: commentsContainerWrapper.trailingAnchor),
            commentsContainerStack.bottomAnchor.constraint(equalTo: commentsContainerWrapper.bottomAnchor)
        ])
        
        // Constrain the wrapper view relative to the content view.
        NSLayoutConstraint.activate([
            commentsContainerWrapper.topAnchor.constraint(equalTo: commentsSummaryStack.bottomAnchor, constant: 16),
            commentsContainerWrapper.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            commentsContainerWrapper.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            // Pin the bottom of the wrapper to the content view so the scroll view can calculate its size.
            commentsContainerWrapper.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        // Add a height constraint on the wrapper that we can animate.
        commentsContainerHeightConstraint = commentsContainerWrapper.heightAnchor.constraint(equalToConstant: 0)
        commentsContainerHeightConstraint.isActive = true
        
        // For demo purposes, create 3 CommentView instances.
        for _ in 0...2 {
            let commentView = CommentView(
                image: UIImage(named: "placeholder"), // Replace with async loading if needed.
                name: "Jeffrey S.",
                time: "2d",
                comment: "I'm a software engineer at Google. I'm interested in learning how to invest."
            )
            commentView.translatesAutoresizingMaskIntoConstraints = false
            commentsContainerStack.addArrangedSubview(commentView)
        }
    }
    
    
    // MARK: - Actions
    @objc private func toggleCommentsVisibility() {
        if !areCommentsVisible {
            // Force layout so that the intrinsic content height is updated.
            commentsContainerStack.layoutIfNeeded()
            let targetHeight = commentsContainerStack.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            commentsContainerHeightConstraint.constant = targetHeight
            showCommentsButton.setTitle("Hide 3 comments", for: .normal)
        } else {
            commentsContainerHeightConstraint.constant = 0
            showCommentsButton.setTitle("Show 3 comments", for: .normal)
        }
        areCommentsVisible.toggle()
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Configuration
    private func configureWithArticle() {
        usernameLabel.text = article.user?.name
        userInfoLabel.text = article.user?.githubUsername
        articleTextLabel.text = article.description
        commentsCountLabel.text = "\(article.commentsCount ?? 0)"
        likesCountLabel.text = "\(article.positiveReactionsCount ?? 0)"
        sharesCountLabel.text = "\(article.publicReactionsCount ?? 0)"
        // The button title and time label are set up in setupCommentsSection.
        
        loadImage(from: article.user?.profileImage90 ?? "", into: profileImageView)
        if let url = URL(string: article.coverImage ?? "") {
            articleImageView.loadImageWithUrl(url)
        } else {
            articleImageView.image = UIImage(named: "placeholder")
        }
    }
    
    private func loadImage(from urlString: String, into imageView: UIImageView) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                imageView.image = image
            }
        }.resume()
    }
}
