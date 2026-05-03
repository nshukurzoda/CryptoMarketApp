//
//  CryptoListViewModel.swift
//  CryproMarketApp
//
//  Created by Nodira Shukurova on 03/05/26.
//
 final class CryptoListViewModel {

    private let networkService = NetworkService()

    private(set) var coins: [Coin] = []

    var onCoinsUpdated: (() -> Void)?
    var onError: ((String) -> Void)?

    func loadCoins() {
        Task {
            do {
                let fetchedCoins = try await networkService.fetchCoins(page: 1)
                self.coins = fetchedCoins

                await MainActor.run {
                    self.onCoinsUpdated?()
                }
            } catch {
                print("REAL NETWORK ERROR:", error)

                await MainActor.run {
                    self.onError?("Failed to load coins: \(error)")
                }
            }
        }
    }

    func coin(at index: Int) -> Coin {
        coins[index]
    }

    var numberOfCoins: Int {
        coins.count
    }
}
