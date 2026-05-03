//
//  NetworkService.swift
//  CryproMarketApp
//
//  Created by Nodira Shukurova on 03/05/26.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case badStatusCode(Int)
}

final class NetworkService {

    func fetchCoins(page: Int, perPage: Int = 20) async throws -> [Coin] {
        var components = URLComponents(string: "https://api.coingecko.com/api/v3/coins/markets")

        components?.queryItems = [
            URLQueryItem(name: "vs_currency", value: "usd"),
            URLQueryItem(name: "order", value: "market_cap_desc"),
            URLQueryItem(name: "per_page", value: "\(perPage)"),
            URLQueryItem(name: "page", value: "\(page)")
        ]

        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }

        print("URL:", url.absoluteString)

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        print("STATUS:", httpResponse.statusCode)

        guard 200...299 ~= httpResponse.statusCode else {
            throw NetworkError.badStatusCode(httpResponse.statusCode)
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return try decoder.decode([Coin].self, from: data)
    }
}
