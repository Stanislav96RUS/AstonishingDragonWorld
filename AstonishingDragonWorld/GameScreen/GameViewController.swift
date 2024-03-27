//
//  GameView.swift
//  AstonishingDragonWorld
//
//  Created by Stanislav on 21.02.2024.
//

import Foundation
import SnapKit
import UIKit

protocol IGameView: AnyObject { }

private extension String {
    static let defaultName = "No name"
    static let defaultUserAvatar = "cloud"
    static let defaulColorDragon = "dragonRed"
    static let defaulObstacles = "meteorite"
}

private enum SoundsGame {
    static let soundGame = "Game"
    static let soundBoom = "Boom"
}

private extension Int {
    static let defaultColorDragonSegmentedValue = 1
    static let defaultDifficultySegmentedValue = 1
    static let defaultTypeOstaclesSegmentedValue = 0
    static let defaultPoint = 0
}

private extension CGFloat {
    static let ratioStringNumber: CGFloat = 5
    static let lineGameCount: CGFloat = 5
    static let sizeScoreCount: CGFloat = 15
}

private extension Double {
    static let startingСountdownDelay: Double = 2
}

private extension TimeInterval {
    static let defaultDifficultyGameSpeed: TimeInterval = 10
    static let defaultDifficultyGameIntensity: TimeInterval = 4
    
    static let defaultAnimateBackgroundSpeed: TimeInterval = 10
    static let trackingBoomObstacle: TimeInterval = 0.1
    
}

final class GameViewController: UIViewController {

    var presenter: IGamePresenter!
    private var soundPlay = AVService()
    private var user = StorageService.shared.loadUser() ?? UserModel(name: .defaultName,
                                                             userAvatar: .defaultUserAvatar,
                                                             colorDragon: .defaulColorDragon,
                                                             typeObstacles: .defaulObstacles,
                                                             difficultyGameSpeed: .defaultDifficultyGameSpeed,
                                                             difficultyGameIntensity: .defaultDifficultyGameIntensity,
                                                             colorDragonSegmentedValue: .defaultColorDragonSegmentedValue,
                                                             obstaclesSegmentedValue: .defaultTypeOstaclesSegmentedValue,
                                                             difficultySegmentedValue: .defaultDifficultySegmentedValue)
    private var arrayUsersRecords = StorageService.shared.loadUsersRecords() ?? []
    
    private var flagFlyMeteorite = true
    private var arrayNewObstacles:Set<UIView> = []
    private var point: Int = .defaultPoint
    private var scoreArray:[[String]] = []
    
    private let animationBackground: UIView = {
        let view = GameBackgroundView().animationBackgroundView
        return view
    }()
    
    private let animationBackground2: UIView = {
        let view = GameBackgroundView().animationBackgroundView
        return view
    }()
    
    private let dragon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: .defaulColorDragon)
        return view
    }()
    
    private let stringNumber: UILabel = {
        let text = UILabel()
        text.frame = CGRect(x: Constants.zeroPoint, y: Constants.zeroPoint, width: UIScreen.main.bounds.width / .ratioStringNumber, height: UIScreen.main.bounds.height / .ratioStringNumber)
        text.font = UIFont(name: Constants.defaultFontName, size: Constants.fontSize.fontSize128)
        text.textColor = Constants.defaultFontColor
        return text
    }()
    
    private let scoreCount: UILabel = {
        let text = UILabel()
        text.frame = CGRect(x: Constants.zeroPoint, y: Constants.zeroPoint, width: .sizeScoreCount, height: .sizeScoreCount)
        text.font = UIFont(name: Constants.defaultFontName, size: Constants.fontSize.fontSize36)
        text.textColor = Constants.defaultFontColor
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
        configureUI()
        setupBehavior()
        setupSwipeControl()
        restartGame()
    }
    
    private func setupSubviews() {
        view.addSubview(animationBackground)
        view.addSubview(animationBackground2)
        view.addSubview(scoreCount)
        view.addSubview(dragon)
        view.addSubview(stringNumber)
    }
    
    private func setupConstraints() {
        
        animationBackground.frame = CGRect(x: Constants.zeroPoint, y: Constants.zeroPoint, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        animationBackground2.frame = CGRect(x: Constants.zeroPoint, y: -UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        dragon.frame = CGRect(x: UIScreen.main.bounds.width / .lineGameCount * (.lineGameCount / 2) - UIScreen.main.bounds.width / .lineGameCount / 2,
                              y: UIScreen.main.bounds.height / .lineGameCount * (.lineGameCount - 1),
                              width: UIScreen.main.bounds.width / .lineGameCount,
                              height: UIScreen.main.bounds.height / .lineGameCount)

        stringNumber.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        scoreCount.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-Constants.offsetSize.offsetSize30)
            make.top.equalToSuperview().offset(Constants.offsetSize.offsetSize30)
        }
    }
    
    private func configureUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        animateBackground()
    }
    
    private func setupBehavior() {
        dragon.image = UIImage(named: user.colorDragon)
    }
    
    private func setupSwipeControl() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
            swipeRight.direction = .right
            self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
            swipeLeft.direction = .left
            self.view.addGestureRecognizer(swipeLeft)
    }
    
    private func restartGame() {
        soundPlay.playSound(SoundsGame.soundGame)
        startingСountdown()
        point = 0
        scoreCount.text = "\(point)"
        flagFlyMeteorite = true
    }
    
    private func animateObstacles(_ obstacles: UIView) {
        UIView.animate(withDuration: user.difficultyGameSpeed, delay: 0, options: [.curveLinear], animations:  {
            obstacles.frame.origin.y += UIScreen.main.bounds.height + obstacles.frame.height
        }, completion: {_ in obstacles.removeFromSuperview()})
    }
    
    private func startFlyNewObstacles() {
        
        let ratioOffset = ((UIScreen.main.bounds.width / .lineGameCount) - ObstaclesView().obstacles.frame.width) / 2
        var newObstaclesArray:[CGFloat] = []
        for i in 0..<Int(.lineGameCount) {
            newObstaclesArray.append((UIScreen.main.bounds.width / .lineGameCount) * CGFloat(i) + ratioOffset)
        }

        let timer = Timer.scheduledTimer(withTimeInterval: user.difficultyGameIntensity, repeats: true, block: { timer in
            let newObstacles = ObstaclesView().obstacles
            newObstacles.image = UIImage(named: self.user.typeObstacles )
            newObstacles.frame = CGRect(x: newObstaclesArray.randomElement()!, y: -newObstacles.frame.height, width: newObstacles.frame.width, height: newObstacles.frame.height)
            self.arrayNewObstacles.insert(newObstacles)
            if self.flagFlyMeteorite == true {
                self.view.addSubview(newObstacles)
                self.animateObstacles(newObstacles)
                self.boomObstacle(newObstacles)
            } else {
                timer.invalidate()
            }
        })
    }

    private func boomObstacle(_ obstacles: UIView) {
        let timer = Timer.scheduledTimer(withTimeInterval: .trackingBoomObstacle, repeats: true, block: { [self] timer in
            if ((obstacles.layer.presentation()?.frame.intersects(dragon.frame))) == true {
                soundPlay.playSound(SoundsGame.soundBoom)
                dellObstacles()
                saveRecords()
                addScoreAlert()
                flagFlyMeteorite = false
                timer.invalidate()
            }
            if obstacles.layer.presentation()?.frame.minY == UIScreen.main.bounds.height {
                point += 1
                scoreCount.text = "\(point)"
                timer.invalidate()
            }
        })
    }
    
    private func saveRecords() {
        let currentDateAndTime = Date.now.formatted(date: .long, time: .shortened)
        let recordUser = UserRecordModel(name: user.name, userAvatar: user.userAvatar, point: point, date: currentDateAndTime)
        arrayUsersRecords.append(recordUser)
    }

    private func dellObstacles() {
        arrayNewObstacles.intersection(view.subviews).map { $0.removeFromSuperview() }
        arrayNewObstacles.removeAll()
    }
    
    private func animateBackground() {
        UIView.animate(withDuration: .defaultAnimateBackgroundSpeed, delay: 0, options: [.curveLinear, .repeat], animations:  {
            self.animationBackground.frame.origin.y += self.view.bounds.height
            
        })
        UIView.animate(withDuration: .defaultAnimateBackgroundSpeed, delay: 0, options: [.curveLinear, .repeat], animations:  {
            self.animationBackground2.frame.origin.y += self.view.bounds.height
            
        })
    }
    
    private func startingСountdown() {
        stringNumber.text = "3"
        self.stringNumber.alpha = 1
        UIView.animate(withDuration: 2, delay: 1, options: .curveEaseInOut, animations: {
            self.stringNumber.alpha = 0.0
        }, completion: { _ in
            self.stringNumber.alpha = 1
            self.stringNumber.text = "2"
            UIView.animate(withDuration: 2, delay: 1, options: .curveEaseInOut, animations: {
                self.stringNumber.alpha = 0.0
            }, completion: { _ in
                self.stringNumber.alpha = 1
                self.stringNumber.text = "1"
                UIView.animate(withDuration: 2, delay: 1, options: .curveEaseInOut, animations: {
                    self.stringNumber.alpha = 0.0
                }, completion: {_ in
                    self.startFlyNewObstacles()
                })
            })
        })
    }
    
    private func addScoreAlert() {
        
        let gameOverAlert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        let attributedStringForTitle = NSAttributedString(string: "\nSCORE", attributes: [NSAttributedString.Key.font: UIFont(name: Constants.defaultFontName, size: Constants.fontSize.fontSize36) as Any, NSAttributedString.Key.foregroundColor: Constants.defaultFontColor])
        gameOverAlert.setValue(attributedStringForTitle, forKey: "attributedTitle")
        let attributedStringForMessage = NSAttributedString(string: "\n\(point)\n", attributes: [NSAttributedString.Key.font: UIFont(name: Constants.defaultFontName, size: Constants.fontSize.fontSize28) as Any, NSAttributedString.Key.foregroundColor: Constants.defaultFontColor])
        
        let height:NSLayoutConstraint = NSLayoutConstraint(
            item: gameOverAlert.view as Any, attribute: NSLayoutConstraint.Attribute.height,
            relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil,
            attribute: NSLayoutConstraint.Attribute.notAnAttribute,
            multiplier: 1, constant: self.view.frame.height * 0.30)
        
        gameOverAlert.view.addConstraint(height)
        gameOverAlert.setValue(attributedStringForMessage, forKey: "attributedMessage")
        gameOverAlert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = .systemIndigo
        gameOverAlert.view.tintColor = Constants.defaultFontColor

        let buttonRestart = UIAlertAction(title: "", style: .default) { (_) in
            StorageService.shared.saveUsersRecords(self.arrayUsersRecords)
            self.restartGame()
        }
        
        let attributedTextButtonRestart = NSMutableAttributedString(string: "RESTART")
        let rangeRestart = NSRange(location: 0, length: attributedTextButtonRestart.length)
        attributedTextButtonRestart.addAttribute(NSAttributedString.Key.kern, value: 1.5, range: rangeRestart)
        attributedTextButtonRestart.addAttribute(NSAttributedString.Key.font, value: UIFont(name: Constants.defaultFontName, size: Constants.fontSize.fontSize20)!, range: rangeRestart)
        
        let buttonMenu = UIAlertAction(title: "", style: .default) { (_) in
            StorageService.shared.saveUsersRecords(self.arrayUsersRecords)
            self.dismiss(animated: true)
            self.navigationController?.popViewController(animated: true)
        }
        
        let attributedTextButtonMenu = NSMutableAttributedString(string: "MENU")
        let rangeMenu = NSRange(location: 0, length: attributedTextButtonMenu.length)
        attributedTextButtonMenu.addAttribute(NSAttributedString.Key.kern, value: 1.5, range: rangeMenu)
        attributedTextButtonMenu.addAttribute(NSAttributedString.Key.font, value: UIFont(name: Constants.defaultFontName, size: Constants.fontSize.fontSize20)!, range: rangeMenu)
        
        gameOverAlert.addAction(buttonRestart)
        gameOverAlert.addAction(buttonMenu)
        
        present(gameOverAlert, animated: true)
        
        guard let label = (buttonRestart.value(forKey: "representer") as AnyObject).value(forKey:"label") as? UILabel else { return }
        label.attributedText = attributedTextButtonRestart
        guard let label = (buttonMenu.value(forKey: "representer") as AnyObject).value(forKey:"label") as? UILabel else { return }
        label.attributedText = attributedTextButtonMenu
        
    }

    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case .right:
                if dragon.frame.origin.x < UIScreen.main.bounds.width - UIScreen.main.bounds.width / .lineGameCount {
                    UIView.animate(withDuration: Constants.animationSettings.defaultWithDuration, delay: Constants.animationSettings.defaultDelay, options: .curveLinear,  animations:  {
                        self.dragon.frame.origin.x += UIScreen.main.bounds.width / .lineGameCount
                    })
                }
            case .left:
                if dragon.frame.origin.x > Constants.zeroPoint {
                    UIView.animate(withDuration: Constants.animationSettings.defaultWithDuration, delay: Constants.animationSettings.defaultDelay, options: .curveLinear, animations:  {
                        self.dragon.frame.origin.x -= UIScreen.main.bounds.width / .lineGameCount
                    })
                }
            default:
                break
            }
        }
    }
}

extension GameViewController: IGameView { }
