//
//  FavoritesService.swift
//  CryproMarketApp
//
//  Created by Nodira Shukurova on 03/05/26.
//

import Foundation

final class FavoritesService {

    static let shared = FavoritesService()

    private let key = "favorite_coin_ids"

    private init() {}

    func getFavoriteIDs() -> [String] {
        UserDefaults.standard.stringArray(forKey: key) ?? []
    }

    func isFavorite(id: String) -> Bool {
        getFavoriteIDs().contains(id)
    }

    func toggleFavorite(id: String) {
        var ids = getFavoriteIDs()

        if ids.contains(id) {
            ids.removeAll { $0 == id }
        } else {
            ids.append(id)
        }

        UserDefaults.standard.set(ids, forKey: key)
    }
}
