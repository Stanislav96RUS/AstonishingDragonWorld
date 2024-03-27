//
//  StartViewButton.swift
//  AstonishingDragonWorld
//
//  Created by Stanislav on 03.03.2024.
//

import UIKit

final class StartViewButton {
    
    var buttonStartView: UIButton = {
        let view = UIButton(type: .roundedRect)
        view.titleLabel?.font = UIFont(name: Constants.defaultFontName , size: Constants.fontSize.fontSize32)
        view.setTitleColor(Constants.defaultFontColor, for: .normal)
        return view
    }()
}
