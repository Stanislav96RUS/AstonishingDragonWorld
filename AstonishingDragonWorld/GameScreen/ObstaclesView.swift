//
//  ObstaclesView.swift
//  AstonishingDragonWorld
//
//  Created by Stanislav on 26.02.2024.
//

import UIKit
import Foundation

private extension CGFloat {
    static let ratioSizeObstacles: CGFloat = 6
}

final class ObstaclesView: UIView {
    let obstacles: UIImageView = {
        let view = UIImageView()
        view.frame = CGRect(x: Constants.zeroPoint, y: Constants.zeroPoint, width: UIScreen.main.bounds.width / .ratioSizeObstacles, height: UIScreen.main.bounds.height / .ratioSizeObstacles)
        return view
    }()
}
