//
//  ArticleDetailViewController.swift
//  SocialNetworkFeed
//
//  Created by Mikhail Ustyantsev on 08.03.2025.
//

import UIKit
import Combine

class ArticleDetailViewController: UIViewController {
    
    // MARK: - Properties
    private var article: Article
    private let viewModel: ArticleDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // Article text and main image
    private let articleTextLabel = UILabel()
    private let articleImageView = ImageLoader()
    
    private lazy var showCommentsButton: UIButton = {
        let button = UIButton(type: .system)
        let count = article.commentsCount ?? 0
        button.setTitle("Show \(count) \(count.pluralized(singular: "comment"))", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let commentTimeLabel = UILabel()
    private lazy var header = ArticleHeaderView(article: article)
    private lazy var interactionView = ArticleInteractionView(article: article)
    private let commentsContainerWrapper = UIView()
    private var commentsContainerHeightConstraint: NSLayoutConstraint!
    
    
    private let commentsContainerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 30
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let commentTextField = UITextField()
    
    private var areCommentsVisible = false
    
    // MARK: - Initializer
    init(article: Article, viewModel: ArticleDetailViewModel) {
        self.article = article
        self.viewModel = viewModel
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
        setupInteractionView()
        setupCommentsSection()
        configureWithArticle()
        setupCommentTextField()
        dismissKeyboardTapGesture()
        bind()
        viewModel.getCommentsFor(article: article.id ?? 0)
    }
    
    private func bind() {
        viewModel.commentsPublisher
            .sink { completion in
                switch completion {
                case .failure(let error):
                    ErrorPresenter.showError(message: "Failure while loading comments. \(error.localizedDescription)", on: self)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] comments in
                guard let self else { return }
                DispatchQueue.main.async {
                    for comment in comments {
                        let commentView = CommentView(
                            image: comment.user.profileImage90,
                            name: comment.user.name ?? "Unknown",
                            time: comment.createdAt,
                            comment: comment.bodyHTML.htmlToString
                        )
                        self.commentsContainerStack.addArrangedSubview(commentView)
                    }
                }
            }
            .store(in: &cancellables)
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
                                                  name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification, object: nil)
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
            // Pin the scrollView to the view edges, leaving space at the bottom for the textField.
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupCommentTextField() {
        view.addSubview(commentTextField)
        commentTextField.placeholder = "Write a comment..."
        commentTextField.clearButtonMode = .whileEditing
        commentTextField.borderStyle = .roundedRect
        commentTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            commentTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            commentTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            commentTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            commentTextField.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    private func setupHeaderSection() {
        header.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(header)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            header.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            header.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupArticleSection() {
        articleTextLabel.numberOfLines = 0
        articleTextLabel.font = UIFont.systemFont(ofSize: 16)
        articleTextLabel.textColor = .label
        articleTextLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(articleTextLabel)
        
        NSLayoutConstraint.activate([
            articleTextLabel.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 16),
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
    
    private func setupInteractionView() {
        interactionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(interactionView)
        
        NSLayoutConstraint.activate([
            interactionView.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: 16),
            interactionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            interactionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupCommentsSection() {
        commentsContainerWrapper.clipsToBounds = true
        // Create a horizontal stack containing the toggle button and time label.
        let commentsSummaryStack = UIStackView(arrangedSubviews: [showCommentsButton, commentTimeLabel])
        commentsSummaryStack.axis = .horizontal
        commentsSummaryStack.alignment = .center
        commentsSummaryStack.distribution = .equalSpacing
        commentsSummaryStack.translatesAutoresizingMaskIntoConstraints = false
        
        if article.commentsCount == 0 {
            commentsSummaryStack.isHidden = true
        }
        
        contentView.addSubview(commentsSummaryStack)
        
        // Configure commentTimeLabel.
        commentTimeLabel.font = R.Font.montserratMedium(with: 14)
        commentTimeLabel.textColor = .secondaryLabel
        commentTimeLabel.text = "5d"
        
        NSLayoutConstraint.activate([
            commentsSummaryStack.topAnchor.constraint(equalTo: interactionView.bottomAnchor, constant: 16),
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
    }
    
    
    // MARK: - Actions
    @objc private func toggleCommentsVisibility() {
        let count = article.commentsCount ?? 0
        if !areCommentsVisible {
            
            commentsContainerStack.layoutIfNeeded()
            let targetHeight = commentsContainerStack.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            commentsContainerHeightConstraint.constant = targetHeight
            showCommentsButton.setTitle("Hide \(count) \(count.pluralized(singular: "comment"))", for: .normal)
        } else {
            commentsContainerHeightConstraint.constant = 0
            showCommentsButton.setTitle("Show \(count) \(count.pluralized(singular: "comment"))", for: .normal)
        }
        areCommentsVisible.toggle()
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Configuration
    private func configureWithArticle() {
        articleTextLabel.text = article.description
        
        if let url = URL(string: article.coverImage ?? "") {
            articleImageView.loadImageWithUrl(url)
        } else {
            articleImageView.image = UIImage(named: "image")
        }
    }
}
