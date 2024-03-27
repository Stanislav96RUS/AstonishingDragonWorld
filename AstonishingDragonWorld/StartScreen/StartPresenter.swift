//
//  StartPresenter.swift
//  AstonishingDragonWorld
//
//  Created by Stanislav on 21.02.2024.
//

import Foundation

protocol IStartPresenter {
    func showGameView()
    func showSettingsView()
    func showRecordsView()
}

final class StartPresenter: IStartPresenter {

    unowned let view: IStartView
    private let router: IStartRouter

    init(view: IStartView, router: IStartRouter) {
        self.view = view
        self.router = router
    }
    func showGameView() {
        router.moveToGameView()
    }
    func showSettingsView() {
        router.moveToSettingsView()
    }
    func showRecordsView() {
        router.moveToRecordsView()
    }
}
