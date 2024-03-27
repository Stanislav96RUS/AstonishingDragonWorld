//
//  GamePresenter.swift
//  AstonishingDragonWorld
//
//  Created by Stanislav on 21.02.2024.
//

import Foundation

protocol IGamePresenter { }

final class GamePresenter: IGamePresenter {

    unowned var view: IGameView
    private let router: IGameRouter

    init(view: IGameView, router: IGameRouter) {
        self.view = view
        self.router = router
    }
}
