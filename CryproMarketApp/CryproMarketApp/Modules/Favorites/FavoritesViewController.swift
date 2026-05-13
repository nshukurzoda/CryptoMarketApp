//
//  FavoritesViewController.swift
//  CryproMarketApp
//
//  Created by Nodira Shukurova on 03/05/26.
//

import UIKit

final class FavoritesViewController: UIViewController {

    private let tableView = UITableView()
    private let emptyLabel = UILabel()
    private let viewModel = FavoritesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupTableView()
        setupEmptyLabel()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.loadFavorites()
    }

    private func setupUI() {
        title = "Favorites"
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

    private func setupEmptyLabel() {
        emptyLabel.text = "No favorite coins yet"
        emptyLabel.textColor = .secondaryLabel
        emptyLabel.font = .systemFont(ofSize: 17, weight: .medium)
        emptyLabel.textAlignment = .center
        emptyLabel.isHidden = true

        view.addSubview(emptyLabel)
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }

    private func bindViewModel() {
        viewModel.onCoinsUpdated = { [weak self] in
            self?.tableView.reloadData()
            self?.emptyLabel.isHidden = self?.viewModel.numberOfCoins != 0
        }

        viewModel.onError = { errorMessage in
            print(errorMessage)
        }
    }
}

// MARK: - UITableViewDataSource

extension FavoritesViewController: UITableViewDataSource {

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

extension FavoritesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        let coin = viewModel.coin(at: indexPath.row)

        let detailsViewController = CryptoDetailsViewController(coin: coin)

        navigationController?.pushViewController(
            detailsViewController,
            animated: true
        )
    }
}
