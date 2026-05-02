//
//  AppDelegate.swift
//  CryproMarketApp
//
//  Created by Nodira Shukurova on 03/05/26.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        let rootVC = CryptoListViewController()
        let navigationController = UINavigationController(rootViewController: rootVC)

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}
