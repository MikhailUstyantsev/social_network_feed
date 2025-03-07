//
//  HomeViewController.swift
//  SocialNetworkFeed
//
//  Created by Mikhail Ustyantsev on 05.03.2025.
//

import UIKit
import Combine
import Alamofire

class HomeViewController: UIViewController {

    enum Section {
        case main
    }
    
    typealias DataSource = UITableViewDiffableDataSource<Section, Article>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Article>
    
    private let tableView = UITableView()
    private var viewModel: HomeViewModel
    private var cancellables = Set<AnyCancellable>()
    private lazy var tableViewDataSource = makeDataSource()
    private let refreshControl = UIRefreshControl()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        viewModel.getArticles(page: 1)
    }

    private func configureViewController() {
        view.backgroundColor = .secondarySystemBackground
        title = R.String.homeVCtitle
        navigationController?.navigationBar.prefersLargeTitles = true
        configureTableView()
        bind()
    }
    
    private func bind() {
        viewModel.articlesPublisher
            .sink { completion in
                    switch completion {
                    case .failure(let error):
                        ErrorPresenter.showError(message: "Response code: \(error.responseCode ?? -1)", on: self)
                    case .finished:
                        break
                    }
                } receiveValue: { [weak self] articles in
                    guard let self else { return }
                    DispatchQueue.main.async {
                        self.applySnapshot(with: articles)
                        if self.tableView.refreshControl?.isRefreshing == true {
                            self.tableView.refreshControl?.endRefreshing()
                        }
                    }
                }
                .store(in: &cancellables)
        }

    private func configureTableView() {
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: String(describing: ArticleTableViewCell.self))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.delegate = self
        
       
       
        tableView.refreshControl = refreshControl
        tableView.refreshControl?.addTarget(self, action: #selector(refreshArticles), for: .valueChanged)
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
    @objc private func refreshArticles() {
        viewModel.clearArticles()
        viewModel.getArticles(page: 1)
    }
    
    // MARK: - DataSource methods
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            tableView: tableView,
            cellProvider: { (tableView, indexPath, item) ->
                UITableViewCell? in
                
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: String(describing: ArticleTableViewCell.self),
                    for: indexPath) as? ArticleTableViewCell
                cell?.configure(with: item)
                cell?.onBookmarkTapped = { [weak self] in
                    guard let self else { return }
                    self.viewModel.toggleBookmark(for: item)
                }
                return cell
            })
        return dataSource
    }
    
    
    private func applySnapshot(with items: [Article], animatingDifferences: Bool = false) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        tableViewDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}


extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
