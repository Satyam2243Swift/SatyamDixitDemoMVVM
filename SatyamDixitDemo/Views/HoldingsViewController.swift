//
//  HoldingsViewController.swift
//  SatyamDixitDemo
//
//  Created by Satyam Dixit on 10/06/25.
//

import UIKit

final class HoldingsViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel = HoldingsViewModel()
    private var summaryHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Constants
    private enum Constants {
        static let summaryExpandedHeight: CGFloat = 120
        static let summaryCollapsedHeight: CGFloat = 0
        static let footerHeight: CGFloat = 50
        static let animationDuration: TimeInterval = 0.25
        static let navBarColor = UIColor(red: 0/255, green: 56/255, blue: 112/255, alpha: 1)
    }
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(HoldingCell.self, forCellReuseIdentifier: HoldingCell.identifier)
        table.dataSource = self
        table.tableFooterView = UIView()
        table.separatorStyle = .singleLine
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return table
    }()
    
    private lazy var summaryView: SummaryView = {
        let view = SummaryView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var footerView: FooterView = {
        let view = FooterView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onToggle = { [weak self] in
            self?.handleToggle()
        }
        return view
    }()
    
    private lazy var footerContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        bindViewModel()
        viewModel.fetchHoldings()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        setupFooterContainer()
        setupTableView()
        setupConstraints()
    }
    
    private func setupNavigationBar() {
        title = "Portfolio"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Constants.navBarColor
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupFooterContainer() {
        footerContainer.addSubview(summaryView)
        footerContainer.addSubview(footerView)
        
        summaryHeightConstraint = summaryView.heightAnchor.constraint(equalToConstant: Constants.summaryCollapsedHeight)
        summaryHeightConstraint.isActive = true
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        view.addSubview(footerContainer)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // TableView constraints
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerContainer.topAnchor),
            
            // Footer container constraints
            footerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // Summary view constraints
            summaryView.topAnchor.constraint(equalTo: footerContainer.topAnchor),
            summaryView.leadingAnchor.constraint(equalTo: footerContainer.leadingAnchor),
            summaryView.trailingAnchor.constraint(equalTo: footerContainer.trailingAnchor),
            
            // Footer view constraints
            footerView.topAnchor.constraint(equalTo: summaryView.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: footerContainer.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: footerContainer.trailingAnchor),
            footerView.heightAnchor.constraint(equalToConstant: Constants.footerHeight),
            
            // Footer container bottom constraint
            footerContainer.bottomAnchor.constraint(equalTo: footerView.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.updateViews()
            }
        }
    }
    
    private func updateViews() {
        summaryView.configure(with: viewModel)
        footerView.configure(pnl: viewModel.totalPNL, expanded: viewModel.isExpanded)
        tableView.reloadData()
    }
    
    private func handleToggle() {
        viewModel.toggleExpanded()
        
        let targetHeight = viewModel.isExpanded ? Constants.summaryExpandedHeight : Constants.summaryCollapsedHeight
        summaryHeightConstraint.constant = targetHeight
        
        UIView.animate(
            withDuration: Constants.animationDuration,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.view.layoutIfNeeded()
            }
        )
        
        updateViews()
    }
}

// MARK: - UITableViewDataSource
extension HoldingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.holdings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HoldingCell.identifier, for: indexPath) as? HoldingCell else {
            return UITableViewCell()
        }
        
        let holding = viewModel.holdings[indexPath.row]
        let pnl = viewModel.pnl(for: holding)
        
        cell.configure(with: holding, pnl: pnl)
        return cell
    }
}
