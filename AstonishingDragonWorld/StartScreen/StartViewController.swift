//
//  StartViewController.swift
//  AstonishingDragonWorld
//
//  Created by Stanislav on 21.02.2024.
//

import AVFoundation
import SnapKit
import UIKit

protocol IStartView: AnyObject { }

private extension Double {
    static let showButtonDelay: Double = 1.5
}

private extension Float {
    static let layerOpacityFalse:Float = 0
    static let layerOpacityTrue:Float = 1
}

private enum StartConstraints {
    static let top = 180
    static let botton = 120
    static let left = 40
    static let spacingMenuItems = 60
}

private enum SoundsMainMenu {
    static let soundBackground = "BackSound"
    static let soundButton = "Start"
}

private extension String {
    static let logoViewImage = "logo"
    static let startButtonText = "START"
    static let settingsButtonText = "SETTINGS"
    static let recordsButtonText = "RECORDS"
}

final class StartViewController: UIViewController {

    var presenter: IStartPresenter!
    
    // MARK: Private
    private var soundPlay = AVService()
    private let gameData = UserDefaults.standard
    
    private let logoView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: .logoViewImage)
        return view
    }()
    
    private let buttonStart: UIView = {
        let view = StartViewButton().buttonStartView
        view.setTitle(.startButtonText, for: .normal)
        view.addTarget(Any?.self, action: #selector(animationBlinkButton), for: .touchDown)
        view.addTarget(Any?.self, action: #selector(showGameButtonDidTapped), for: .touchUpInside)
       return view
    }()
    
    private let buttonSettings: UIView = {
        let view = StartViewButton().buttonStartView
        view.setTitle(.settingsButtonText, for: .normal)
        view.addTarget(Any?.self, action: #selector(animationBlinkButton), for: .touchDown)
        view.addTarget(Any?.self, action: #selector(showSettingsButtonDidTapped), for: .touchUpInside)
       return view
    }()
    
    private let buttonRecords: UIButton = {
        let view = StartViewButton().buttonStartView
        view.setTitle(.recordsButtonText, for: .normal)
        view.addTarget(Any?.self, action: #selector(animationBlinkButton), for: .touchDown)
        view.addTarget(Any?.self, action: #selector(showRecordsButtonDidTapped), for: .touchUpInside)
       return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        soundPlay.playSound(SoundsMainMenu.soundBackground)
    }

    private func setupSubviews() {
        view.addSubview(logoView)
        view.addSubview(buttonStart)
        view.addSubview(buttonSettings)
        view.addSubview(buttonRecords)
    }
    
    private func setupConstraints() {
        logoView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(StartConstraints.top)
            make.left.equalToSuperview().offset(StartConstraints.left)
        }
        buttonStart.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoView).offset(StartConstraints.botton)
        }
        buttonSettings.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(buttonStart).offset(StartConstraints.spacingMenuItems)
        }
        buttonRecords.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(buttonSettings).offset(StartConstraints.spacingMenuItems)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = Constants.defaultBackgroundColor
    }
    
    @objc private func showGameButtonDidTapped() {
        delay(.showButtonDelay) {
            self.presenter.showGameView()
        }
    }
    @objc private func showSettingsButtonDidTapped() {
        delay(.showButtonDelay) {
            self.presenter.showSettingsView()
        }
    }
    @objc private func showRecordsButtonDidTapped() {
        delay(.showButtonDelay) {
            self.presenter.showRecordsView()
        }
    }
    @objc private func animationBlinkButton(_ button: UIView ) {
        soundPlay.playSound(SoundsMainMenu.soundButton)
        UIView.animate(withDuration: Constants.animationSettings.defaultWithDuration,
                       delay: Constants.animationSettings.defaultDelay,
                       options: [.repeat, .autoreverse],
                       animations: { button.layer.opacity = .layerOpacityFalse },
                       completion: { _ in button.layer.opacity = .layerOpacityTrue }
        )
    }
}

extension StartViewController: IStartView { }
