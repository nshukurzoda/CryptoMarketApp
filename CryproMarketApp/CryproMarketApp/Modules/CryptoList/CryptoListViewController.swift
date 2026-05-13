//
//  CryptoListViewController.swift
//  CryproMarketApp
//
//  Created by Nodira Shukurova on 03/05/26.
//
import UIKit

final class CryptoListViewController: UIViewController {

    private let tableView = UITableView()
    private let viewModel = CryptoListViewModel()
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupTableView()
        bindViewModel()
        setupRefreshControl()

        viewModel.loadCoins()
    }

    private func setupUI() {
        title = "Crypto Market"
        view.backgroundColor = .systemBackground
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CryptoCell.self, forCellReuseIdentifier: CryptoCell.reuseID)

        tableView.rowHeight = 72
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 68, bottom: 0, right: 16)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func bindViewModel() {
        viewModel.onCoinsUpdated = { [weak self]  in
            
            DispatchQueue.main.async {
                
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }

            viewModel.onError = { errorMessage in
                print(errorMessage)
            }
        
       
    }
    
    private func setupRefreshControl() {

        tableView.refreshControl = refreshControl

        refreshControl.addTarget(
            self,
            action: #selector(refreshData),
            for: .valueChanged
        )
    }
    
    @objc private func refreshData() {
        viewModel.loadCoins()
    }
    
}

// MARK: - UITableViewDataSource

extension CryptoListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfCoins
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CryptoCell.reuseID,
            for: indexPath
        ) as? CryptoCell else {
            return UITableViewCell()
        }

        let coin = viewModel.coin(at: indexPath.row)
        cell.configure(with: coin)

        return cell
    }
}

// MARK: - UITableViewDelegate
    
extension CryptoListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let coin = viewModel.coin(at: indexPath.row)
        let detailsViewModel = CryptoDetailsViewModel(coin: coin)
        let detailsViewController = CryptoDetailsViewController(viewModel: detailsViewModel)

        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}
