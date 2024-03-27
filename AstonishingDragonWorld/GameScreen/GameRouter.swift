//
//  GameRouter.swift
//  AstonishingDragonWorld
//
//  Created by Stanislav on 21.02.2024.
//

import UIKit

protocol IGameRouter { }

final class GameRouter {

    let navigationController: UINavigationController
    let window: UIWindow

    init(navigationController: UINavigationController, window: UIWindow) {
        self.navigationController = navigationController
        self.window = window
        let view = GameViewController()
        let presenter = GamePresenter(view: view, router: self)
        view.presenter = presenter
        navigationController.pushViewController(view, animated: true)
    }
}

extension GameRouter: IGameRouter { }
