//
//  CryptoListCell.swift
//  CryproMarketApp
//
//  Created by Nodira Shukurova on 03/05/26.
//

import UIKit

final class CryptoCell: UITableViewCell {

    static let reuseID = "CryptoCell"

    private let coinImageView = UIImageView()
    private let nameLabel = UILabel()
    private let symbolLabel = UILabel()
    private let priceLabel = UILabel()
    private let changeLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        coinImageView.image = UIImage(systemName: "bitcoinsign.circle.fill")
        nameLabel.text = nil
        symbolLabel.text = nil
        priceLabel.text = nil
        changeLabel.text = nil
    }

    private func setupUI() {
        selectionStyle = .none

        coinImageView.contentMode = .scaleAspectFit
        coinImageView.backgroundColor = .secondarySystemBackground
        coinImageView.layer.cornerRadius = 20
        coinImageView.clipsToBounds = true
        coinImageView.image = UIImage(systemName: "bitcoinsign.circle.fill")

        nameLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        nameLabel.textColor = .label

        symbolLabel.font = .systemFont(ofSize: 13, weight: .medium)
        symbolLabel.textColor = .secondaryLabel

        priceLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        priceLabel.textColor = .label
        priceLabel.textAlignment = .right

        changeLabel.font = .systemFont(ofSize: 13, weight: .medium)
        changeLabel.textAlignment = .right
    }

    private func setupLayout() {
        [coinImageView, nameLabel, symbolLabel, priceLabel, changeLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            coinImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            coinImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            coinImageView.widthAnchor.constraint(equalToConstant: 40),
            coinImageView.heightAnchor.constraint(equalToConstant: 40),

            nameLabel.leadingAnchor.constraint(equalTo: coinImageView.trailingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: priceLabel.leadingAnchor, constant: -12),

            symbolLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            symbolLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            symbolLabel.trailingAnchor.constraint(lessThanOrEqualTo: priceLabel.leadingAnchor, constant: -12),

            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            priceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),

            changeLabel.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor),
            changeLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4),
            changeLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -14)
        ])
    }

    func configure(with coin: Coin) {
        nameLabel.text = coin.name
        symbolLabel.text = coin.symbol.uppercased()
        priceLabel.text = "$\(coin.currentPrice)"

        if let change = coin.priceChangePercentage24h {
            changeLabel.text = String(format: "%.2f%%", change)
            changeLabel.textColor = change >= 0 ? .systemGreen : .systemRed
        } else {
            changeLabel.text = "—"
            changeLabel.textColor = .secondaryLabel
        }

        coinImageView.image = UIImage(systemName: "bitcoinsign.circle.fill")

        ImageLoader.shared.loadImage(from: coin.image) { [weak self] image in
            self?.coinImageView.image = image ?? UIImage(systemName: "bitcoinsign.circle.fill")
        }
    }
}
