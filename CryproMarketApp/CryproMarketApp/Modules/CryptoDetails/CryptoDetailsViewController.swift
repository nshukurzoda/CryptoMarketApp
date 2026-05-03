//
//  CryptoDetailsViewController.swift
//  CryproMarketApp
//
//  Created by Nodira Shukurova on 03/05/26.
//

import UIKit

final class CryptoDetailsViewController: UIViewController {

    private let viewModel: CryptoDetailsViewModel
    private var isFavorite: Bool {
        FavoritesService.shared.isFavorite(id: viewModel.coin.id)
    }
    private let coinImageView = UIImageView()
    private let nameLabel = UILabel()
    private let symbolLabel = UILabel()
    private let priceLabel = UILabel()
    private let changeLabel = UILabel()
    private let marketCapTitleLabel = UILabel()
    private let marketCapValueLabel = UILabel()

    init(viewModel: CryptoDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupNavigationBar()
        setupLayout()
        configure()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        coinImageView.contentMode = .scaleAspectFit
        coinImageView.backgroundColor = .secondarySystemBackground
        coinImageView.layer.cornerRadius = 60
        coinImageView.clipsToBounds = true

        nameLabel.font = .systemFont(ofSize: 28, weight: .bold)
        nameLabel.textAlignment = .center

        symbolLabel.font = .systemFont(ofSize: 16, weight: .medium)
        symbolLabel.textColor = .secondaryLabel
        symbolLabel.textAlignment = .center

        priceLabel.font = .systemFont(ofSize: 26, weight: .semibold)
        priceLabel.textAlignment = .center

        changeLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        changeLabel.textAlignment = .center

        marketCapTitleLabel.text = "Market Cap"
        marketCapTitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        marketCapTitleLabel.textColor = .secondaryLabel

        marketCapValueLabel.font = .systemFont(ofSize: 20, weight: .semibold)
    }

    private func setupNavigationBar() {
        title = viewModel.title

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: isFavorite ? "heart.fill" : "heart"),
            style: .plain,
            target: self,
            action: #selector(favoriteButtonTapped)
        )

        navigationItem.rightBarButtonItem?.tintColor = .systemRed
    }

    private func setupLayout() {
        [coinImageView,
         nameLabel,
         symbolLabel,
         priceLabel,
         changeLabel,
         marketCapTitleLabel,
         marketCapValueLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            coinImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            coinImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coinImageView.widthAnchor.constraint(equalToConstant: 120),
            coinImageView.heightAnchor.constraint(equalToConstant: 120),

            nameLabel.topAnchor.constraint(equalTo: coinImageView.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            symbolLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            symbolLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            symbolLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            priceLabel.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor, constant: 32),
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            changeLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            changeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            changeLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            marketCapTitleLabel.topAnchor.constraint(equalTo: changeLabel.bottomAnchor, constant: 40),
            marketCapTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),

            marketCapValueLabel.topAnchor.constraint(equalTo: marketCapTitleLabel.bottomAnchor, constant: 8),
            marketCapValueLabel.leadingAnchor.constraint(equalTo: marketCapTitleLabel.leadingAnchor),
            marketCapValueLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }

    private func configure() {
        nameLabel.text = viewModel.title
        symbolLabel.text = viewModel.symbol
        priceLabel.text = viewModel.priceText
        changeLabel.text = viewModel.changeText
        changeLabel.textColor = viewModel.isChangePositive ? .systemGreen : .systemRed
        marketCapValueLabel.text = viewModel.marketCapText

        coinImageView.image = UIImage(systemName: "bitcoinsign.circle.fill")

        ImageLoader.shared.loadImage(from: viewModel.imageURL) { [weak self] image in
            self?.coinImageView.image = image ?? UIImage(systemName: "bitcoinsign.circle.fill")
        }
    }
    @objc private func favoriteButtonTapped() {
        FavoritesService.shared.toggleFavorite(id: viewModel.coin.id)

        let imageName = isFavorite ? "heart.fill" : "heart"
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: imageName)

        print("FAVORITES:", FavoritesService.shared.getFavoriteIDs())
    }
}
