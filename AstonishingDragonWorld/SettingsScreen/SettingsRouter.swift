//
//  SettingsRouter.swift
//  AstonishingDragonWorld
//
//  Created by Stanislav on 21.02.2024.
//

import UIKit

protocol ISettingsRouter { }

final class SettingsRouter {
    
    let navigationController: UINavigationController
    let window: UIWindow
    
    init(navigationController: UINavigationController, window: UIWindow) {
        self.navigationController = navigationController
        self.window = window
        let view = SettingsViewController()
        let presenter = SettingsPresenter(view: view, router: self)
        view.presenter = presenter
        navigationController.pushViewController(view, animated: true)
    }
}

extension SettingsRouter: ISettingsRouter { }
