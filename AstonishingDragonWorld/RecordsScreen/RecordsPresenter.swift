//
//  RecordsPresenter.swift
//  AstonishingDragonWorld
//
//  Created by Stanislav on 21.02.2024.
//

import Foundation

protocol IRecordsPresenter { }

final class RecordsPresenter: IRecordsPresenter {

    unowned var view: IRecordsView
    private let router: IRecordsRouter

    init(view: IRecordsView, router: IRecordsRouter) {
        self.view = view
        self.router = router
    }
}
