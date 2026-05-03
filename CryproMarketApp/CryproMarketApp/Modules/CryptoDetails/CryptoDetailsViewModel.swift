//
//  CryptoDetailsViewModel.swift
//  CryproMarketApp
//
//  Created by Nodira Shukurova on 03/05/26.
//

import Foundation

final class CryptoDetailsViewModel {

    let coin: Coin

    init(coin: Coin) {
        self.coin = coin
    }

    var title: String {
        coin.name
    }

    var symbol: String {
        coin.symbol.uppercased()
    }

    var priceText: String {
        "$\(coin.currentPrice)"
    }

    var changeText: String {
        guard let change = coin.priceChangePercentage24h else {
            return "—"
        }

        return String(format: "%.2f%%", change)
    }

    var marketCapText: String {
        guard let marketCap = coin.marketCap else {
            return "—"
        }

        return "$\(marketCap)"
    }

    var imageURL: String {
        coin.image
    }

    var isChangePositive: Bool {
        (coin.priceChangePercentage24h ?? 0) >= 0
    }
}
