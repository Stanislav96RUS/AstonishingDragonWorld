//
//  ScoreTableViewCell.swift
//  AstonishingDragonWorld
//
//  Created by Stanislav on 01.03.2024.
//

import Foundation
import SnapKit
import UIKit

private extension CGFloat {
    static let sizeAvatar: CGFloat = 80
    static let borderWidth: CGFloat = 3
    static let ratioCornerRadius: CGFloat = 2
}
   
private enum Offset {
    static let dateOffset: CGFloat = 40
}

class ScoreTableViewCell: UITableViewCell {
    
    let avatarImage: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = .sizeAvatar / .ratioCornerRadius
        view.clipsToBounds = true
        view.layer.borderWidth = .borderWidth
        view.layer.borderColor = Constants.defaultBorderColor
        return view
    }()
    
    let userName: UILabel = {
        let lable = UILabel()
        lable.textColor = Constants.defaultFontColor
        lable.font = UIFont(name: Constants.defaultFontName, size: Constants.fontSize.fontSize24)
        return lable
    }()
    
    let scorePiont: UILabel = {
        let lable = UILabel()
        lable.textColor = Constants.defaultFontColor
        lable.font = UIFont(name: Constants.defaultFontName, size: Constants.fontSize.fontSize24)
        return lable
    }()
    
    let date: UILabel = {
        let lable = UILabel()
        lable.textColor = Constants.defaultFontColor
        lable.font = UIFont(name: Constants.defaultFontName, size: Constants.fontSize.fontSize18)
        return lable
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(avatarImage)
        addSubview(userName)
        addSubview(scorePiont)
        addSubview(date)
       
        userName.snp.makeConstraints { make in
            make.top.equalTo(avatarImage)
            make.right.equalToSuperview().inset(Constants.offsetSize.offsetSize10)
        }
        
        scorePiont.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(avatarImage)
        }
        
        date.snp.makeConstraints { make in
            make.right.equalTo(userName)
            make.top.equalTo(userName).offset(Offset.dateOffset)
        }
        
        avatarImage.frame = CGRect(x: Constants.offsetSize.offsetSize10,
                                   y: Constants.offsetSize.offsetSize10,
                                   width: .sizeAvatar,
                                   height: .sizeAvatar)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
