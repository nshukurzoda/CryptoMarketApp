//
//  FavoritesViewModel.swift
//  CryproMarketApp
//
//  Created by Nodira Shukurova on 03/05/26.
//
import Foundation

final class FavoritesViewModel {

    private let networkService = NetworkService()
    private(set) var coins: [Coin] = []

    var onCoinsUpdated: (() -> Void)?
    var onError: ((String) -> Void)?

    var numberOfCoins: Int {
        coins.count
    }

    func coin(at index: Int) -> Coin {
        coins[index]
    }

    func loadFavorites() {
        Task {
            do {
                let allCoins = try await networkService.fetchCoins(page: 1, perPage: 100)
                let favoriteIDs = FavoritesService.shared.getFavoriteIDs()

                self.coins = allCoins.filter {
                    favoriteIDs.contains($0.id)
                }

                await MainActor.run {
                    self.onCoinsUpdated?()
                }
            } catch {
                await MainActor.run {
                    self.onError?("Failed to load favorite coins")
                }
            }
        }
    }
}
