//
//  GameBackgroundView.swift
//  AstonishingDragonWorld
//
//  Created by Stanislav on 03.03.2024.
//

import UIKit

final class GameBackgroundView {
    let animationBackgroundView: UIView = {
        let view = UIImageView()
        view.image = UIImage(named: "BackGroundGame")
        return view
    }()
}
