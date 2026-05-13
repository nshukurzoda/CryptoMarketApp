//
//  CryptoListViewModel.swift
//  CryproMarketApp
//
//  Created by Nodira Shukurova on 03/05/26.
//
 final class CryptoListViewModel {

    private let networkService = NetworkService()

    private(set) var coins: [Coin] = []
     
     private var currentPage = 1
     private var isLoading = false
     private var hasMoreData = true

    var onCoinsUpdated: (() -> Void)?
    var onError: ((String) -> Void)?

     func loadCoins() {

         currentPage = 1
         hasMoreData = true

         Task {

             do {

                 let fetchedCoins = try await networkService.fetchCoins(page: currentPage)

                 self.coins = fetchedCoins

                 await MainActor.run {
                     self.onCoinsUpdated?()
                 }

             } catch {

                 await MainActor.run {
                     self.onError?("Failed to load coins: \(error)")
                 }
             }
         }
     }
     
     func loadNextPage() {

         guard !isLoading else { return }
         guard hasMoreData else { return }

         isLoading = true

         currentPage += 1

         Task {

             do {

                 let newCoins = try await networkService.fetchCoins(page: currentPage)

                 if newCoins.isEmpty {
                     hasMoreData = false
                 }

                 self.coins.append(contentsOf: newCoins)

                 isLoading = false

                 await MainActor.run {
                     self.onCoinsUpdated?()
                 }

             } catch {

                 isLoading = false

                 await MainActor.run {
                     self.onError?("Failed to load more coins: \(error)")
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
