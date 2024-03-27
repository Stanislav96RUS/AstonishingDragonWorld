//
//  StartRouter.swift
//  AstonishingDragonWorld
//
//  Created by Stanislav on 21.02.2024.
//

import UIKit

protocol IStartRouter {
    func moveToGameView()
    func moveToSettingsView()
    func moveToRecordsView()
}

final class StartRouter {

    private let navigationController: UINavigationController
    private let window: UIWindow
    
    init(navigationController: UINavigationController, window: UIWindow) {
        self.navigationController = navigationController
        self.window = window
        let view = StartViewController()
        let presenter = StartPresenter(view: view, router:  self)
        view.presenter =  presenter
        navigationController.pushViewController(view, animated: true)
    }
}

extension StartRouter: IStartRouter {
    func moveToGameView() {
        let _ = GameRouter(navigationController: navigationController, window: window)
    }
    func moveToSettingsView() {
        let _ = SettingsRouter(navigationController: navigationController, window: window)
    }
    func moveToRecordsView() {
        let _ = RecordsRouter(navigationController: navigationController, window: window)
    }
}
