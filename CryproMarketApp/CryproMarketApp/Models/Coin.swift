//
//  Coin.swift
//  CryproMarketApp
//
//  Created by Nodira Shukurova on 03/05/26.
//

import Foundation

struct Coin: Decodable {
    let id: String
    let symbole: String
    let name: String
    let image: String
    let currentPrice: Double
    let priceChangePercentage24H: Double
    let marketCap: Double?
}
