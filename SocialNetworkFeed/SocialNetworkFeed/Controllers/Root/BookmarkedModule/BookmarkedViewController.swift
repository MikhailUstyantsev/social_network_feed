//
//  BookmarkedViewController.swift
//  SocialNetworkFeed
//
//  Created by Mikhail Ustyantsev on 08.03.2025.
//

import UIKit
import Combine

class BookmarkedViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    private let viewModel: BookmarkedViewModel
    private let tableView = UITableView()
    private var cancellables = Set<AnyCancellable>()
    private lazy var tableViewDataSource = makeDataSource()
    
    typealias DataSource = UITableViewDiffableDataSource<Section, BookmarkedArticle>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, BookmarkedArticle>
    
    init(viewModel: BookmarkedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getBookmarkedArticles()
    }
    
    
    private func configureViewController() {
        view.backgroundColor = .secondarySystemBackground
        title = "Bookmarked"
        navigationController?.navigationBar.prefersLargeTitles = true
        configureTableView()
        bind()
    }
    
    
    //MARK: - Binding
    private func bind() {
        viewModel.bookmarkedPublisher
            .sink { completion in
                switch completion {
                case .failure(let error):
                    ErrorPresenter.showError(message: "\(error.rawValue)", on: self)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] articles in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.applySnapshot(with: articles)
                }
            }
            .store(in: &cancellables)
    }
    
    private func configureTableView() {
        tableView.register(BookmarkedTableViewCell.self, forCellReuseIdentifier: String(describing: BookmarkedTableViewCell.self))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.delegate = self
        
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
    // MARK: - DataSource methods
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            tableView: tableView,
            cellProvider: { (tableView, indexPath, item) ->
                UITableViewCell? in
                
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: String(describing: BookmarkedTableViewCell.self),
                    for: indexPath) as? BookmarkedTableViewCell
                cell?.configure(with: item)
                cell?.onBookmarkTapped = { [weak self] in
                    guard let self else { return }
                    let alert = UIAlertController(title: "", message: "Delete bookmarked item?", preferredStyle: .actionSheet)
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    
                    let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                        guard let self else { return }
                        self.viewModel.storageManager.removeBookmark(articleID: Int(item.id))
                        self.viewModel.getBookmarkedArticles()
                        NotificationCenter.default.post(name: .bookmarkUpdated, object: nil)
                    }
                    alert.addAction(cancelAction)
                    alert.addAction(deleteAction)
                    
                    present(alert, animated: true)
                }
                return cell
            })
        return dataSource
    }
    
    
    private func applySnapshot(with items: [BookmarkedArticle], animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        tableViewDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}


extension BookmarkedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let bookmarkedArticle = tableViewDataSource.itemIdentifier(for: indexPath) else { return }
        let article = convert(bookmarkedArticle: bookmarkedArticle)
        
        let viewModel = ArticleDetailViewModel()
        let detailViewController = ArticleDetailViewController(
            article: article,
            viewModel: viewModel
        )
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
