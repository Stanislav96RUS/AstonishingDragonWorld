//
//  SettingsPresenter.swift
//  AstonishingDragonWorld
//
//  Created by Stanislav on 21.02.2024.
//

import Foundation

protocol ISettingsPresenter { }

final class SettingsPresenter: ISettingsPresenter {

    unowned var view: ISettingsView
    private let router: ISettingsRouter

    init(view: ISettingsView, router: ISettingsRouter) {
        self.view = view
        self.router = router
    }
}
