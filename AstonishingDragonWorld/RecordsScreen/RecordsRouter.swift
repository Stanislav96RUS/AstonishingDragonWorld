//
//  RecordsRouter.swift
//  AstonishingDragonWorld
//
//  Created by Stanislav on 21.02.2024.
//

import UIKit

protocol IRecordsRouter { }

final class RecordsRouter {

    let navigationController: UINavigationController
    let window: UIWindow
    
    init(navigationController: UINavigationController, window: UIWindow) {
        self.navigationController = navigationController
        self.window = window
        let view = RecordsViewController()
        let presenter = RecordsPresenter(view: view, router: self)
        view.presenter = presenter
        navigationController.pushViewController(view, animated: true)
    }
}

extension RecordsRouter: IRecordsRouter { }
