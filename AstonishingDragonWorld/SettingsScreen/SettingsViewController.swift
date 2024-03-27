//
//  SettingsViewController.swift
//  AstonishingDragonWorld
//
//  Created by Stanislav on 21.02.2024.
//

import UIKit
import SnapKit

protocol ISettingsView: AnyObject { }

private enum SegmentedControlArray {
    static let colorDragonSegmentedControlArray:[String] = ["RED", "BLUE", "GREEN"]
    static let difficultySegmentedItemsArray:[String] = ["EASY", "MEDIUM", "HARD"]
    static let obstaclesSegmentedControlArray:[String] = ["METEORITE", "COMET", "ASTEROID"]
}

private enum DifficultyGameSpeed: TimeInterval {
    case easy = 15
    case medium = 10
    case hard = 5
}
private enum DifficultyGameIntensity: TimeInterval {
    case easy = 6
    case medium = 4
    case hard = 2
}

private enum BorderWidth {
    static let borderWidthAvatar: CGFloat = 3
    static let borderWidthSegmentedControl: CGFloat = 1
}

private enum CornerRadius {
    static let cornerRadiusEditAvatar: CGFloat = 10
}

private enum Offset {
    static let offset20: CGFloat = 20
    static let offset50: CGFloat = 50
}

private extension TimeInterval {
    static let defaultDifficultyGameSpeed:TimeInterval = 10
    static let defaultDifficultyGameIntensity:TimeInterval = 4
    static let speedEasy:TimeInterval = 15
    static let speedMedium:TimeInterval = 10
    static let speedHard:TimeInterval = 5
    static let intensityEasy:TimeInterval = 6
    static let intensityMedium:TimeInterval = 4
    static let intensityHard:TimeInterval = 2
}

private extension Int {
    static let defaultColorDragonSegmentedValue = 1
    static let defaultIndexDifficultySegmentedValue = 1
    static let defaultTypeOstaclesSegmentedValue = 0
}

private extension String {
    static let edit = "EDIT"
    static let editUserNameButton = "square.and.pencil"
    static let saveUserNameButton = "square.and.arrow.down"
    
    static let soundSettings = "Settings"
    
    static let copyFileName = "AvatarImage"
    
    static let defaultName = "Anonymous"
    static let defaultPlaceholder = "You Name"
    static let defaultUserAvatar = "noAvatarImage"
    
    static let dragonRed = "dragonRed"
    static let dragonBlue = "dragonBlue"
    static let dragonGreen = "dragonGreen"
    
    static let meteorite = "meteorite"
    static let comet = "comet"
    static let asteroid = "asteroid"
    
    static let difficultySegmentedName = "DIFFICULTY"
    static let colorDragonSegmentedName = "COLOR DRAGON"
    static let obstaclesSegmentedName = "OBSTACLES"
}

final class SettingsViewController: UIViewController {
    
    var presenter: ISettingsPresenter!

    private var soundPlay = AVService()
    private var user = StorageService.shared.loadUser() ?? UserModel(name: .defaultName,
                                                             userAvatar: .defaultUserAvatar,
                                                             colorDragon: .dragonRed,
                                                             typeObstacles: .meteorite,
                                                             difficultyGameSpeed: .defaultDifficultyGameSpeed,
                                                             difficultyGameIntensity: .defaultDifficultyGameIntensity,
                                                             colorDragonSegmentedValue: .defaultColorDragonSegmentedValue,
                                                             obstaclesSegmentedValue: .defaultTypeOstaclesSegmentedValue,
                                                             difficultySegmentedValue: .defaultIndexDifficultySegmentedValue)
    
    private let imagePicker = ImagePicker()
    
    private let buttonBack: UIView = {
        let view = UIButton()
        view.setTitle(Constants.backButton, for: .normal)
        view.setTitleColor(Constants.defaultFontColor, for: .normal)
        view.titleLabel?.font = UIFont(name: Constants.defaultFontName, size: Constants.fontSize.fontSize18)
        view.addTarget(Any?.self, action: #selector(popSettingsButtonDidTapped), for: .touchUpInside)
        return view
    }()
    
    private let avatarView: UIImageView = {
        let view = UIImageView()
        view.frame = CGRect(x: 30, y: 100, width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)
        view.layer.cornerRadius = UIScreen.main.bounds.width / 3 / 2
        view.clipsToBounds = true
        view.layer.borderWidth = BorderWidth.borderWidthAvatar
        view.layer.borderColor = Constants.defaultBorderColor
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let editAvatarButton: UIButton = {
        let view = UIButton(type: .roundedRect)
        view.setTitle(.edit, for: .normal)
        view.titleLabel?.font = UIFont(name: Constants.defaultFontName, size: Constants.fontSize.fontSize12)
        view.setTitleColor(Constants.defaultBackgroundColor, for: .normal)
        view.backgroundColor = Constants.defaultFontColor
        view.layer.cornerRadius = CornerRadius.cornerRadiusEditAvatar
        view.addTarget(Any?.self, action: #selector(chooseImagePhotoLibrary), for: .touchUpInside)
        return view
    }()
    
    private let userNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = .defaultPlaceholder
        textField.backgroundColor = Constants.defaultFontColor
        textField.textColor = .gray
        textField.font = UIFont(name: Constants.defaultFontName, size: Constants.fontSize.fontSize28)
        textField.isHidden = true
        return textField
    }()
    
    private let editUserNameTextFieldButton: UIButton = {
        let text = UIButton(type: .custom)
        let image = UIImage(systemName: .editUserNameButton)?.withTintColor(Constants.defaultFontColor, renderingMode: .alwaysOriginal)
        text.setImage(image, for: .normal)
        text.setTitleColor(Constants.defaultFontColor, for: .normal)
        text.isHidden = false
        text.addTarget(Any?.self, action: #selector(userNameChange), for: .touchUpInside)
        return text
    }()
    
    private let saveUserNameTextFieldButton: UIButton = {
        let text = UIButton(type: .custom)
        let image = UIImage(systemName: .saveUserNameButton)?.withTintColor(Constants.defaultFontColor, renderingMode: .alwaysOriginal)
        text.setImage(image, for: .normal)
        text.setTitleColor(Constants.defaultFontColor, for: .normal)
        text.isHidden = true
        text.addTarget(Any?.self, action: #selector(saveUserNameToLable), for: .touchUpInside)
        return text
    }()

    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.defaultFontColor
        label.font = UIFont(name: Constants.defaultFontName, size: Constants.fontSize.fontSize28)
        label.isHidden = false
        return label
    }()
    
    private let difficultySegmentedLabel: UILabel = {
        let label = UILabel()
        label.text = .difficultySegmentedName
        label.textColor = Constants.defaultFontColor
        label.font = UIFont(name: Constants.defaultFontName, size: Constants.fontSize.fontSize18)
        return label
    }()
    
    private let difficultySegmentedControl: UISegmentedControl = {
        let difficultySegmentedItems = SegmentedControlArray.difficultySegmentedItemsArray
        let segmentedControl = UISegmentedControl(items: difficultySegmentedItems)
        segmentedControl.backgroundColor = Constants.defaultBackgroundColor
        segmentedControl.selectedSegmentTintColor = Constants.defaultFontColor
        segmentedControl.layer.borderColor = Constants.defaultBorderColor
        segmentedControl.layer.borderWidth = BorderWidth.borderWidthSegmentedControl
        let titleTextAttributesNormal = [NSAttributedString.Key.foregroundColor: Constants.defaultFontColor]
        segmentedControl.setTitleTextAttributes(titleTextAttributesNormal, for:.normal)
        let titleTextAttributesSelected = [NSAttributedString.Key.foregroundColor: Constants.defaultBackgroundColor]
        segmentedControl.setTitleTextAttributes(titleTextAttributesSelected, for:.selected)
        segmentedControl.addTarget(Any?.self, action: #selector(difficultySegmentedValueChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    private let colorDragonSegmentedLabel: UILabel = {
        let label = UILabel()
        label.text = .colorDragonSegmentedName
        label.textColor = Constants.defaultFontColor
        label.font = UIFont(name: Constants.defaultFontName, size: Constants.fontSize.fontSize18)
        return label
    }()
    
    private let colorDragonSegmentedControl: UISegmentedControl = {
        let colorDragonSegmentedItems = SegmentedControlArray.colorDragonSegmentedControlArray
        let segmentedControl = UISegmentedControl(items: colorDragonSegmentedItems)
        segmentedControl.backgroundColor = Constants.defaultBackgroundColor
        segmentedControl.selectedSegmentTintColor = Constants.defaultFontColor
        segmentedControl.layer.borderColor = Constants.defaultBorderColor
        segmentedControl.layer.borderWidth = BorderWidth.borderWidthSegmentedControl
        let titleTextAttributesNormal = [NSAttributedString.Key.foregroundColor: Constants.defaultFontColor]
        segmentedControl.setTitleTextAttributes(titleTextAttributesNormal, for:.normal)
        let titleTextAttributesSelected = [NSAttributedString.Key.foregroundColor: UIColor.cyan]
        segmentedControl.setTitleTextAttributes(titleTextAttributesSelected, for:.selected)
        segmentedControl.addTarget(Any?.self, action: #selector(colorDragonSegmentedValueChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    private let obstaclesSegmentedLabel: UILabel = {
        let label = UILabel()
        label.text = .obstaclesSegmentedName
        label.textColor = Constants.defaultFontColor
        label.font = UIFont(name: Constants.defaultFontName, size: Constants.fontSize.fontSize18)
        return label
    }()
    
    private let obstaclesSegmentedControl: UISegmentedControl = {
        let obstaclesSegmentedItems = SegmentedControlArray.obstaclesSegmentedControlArray
        let segmentedControl = UISegmentedControl(items: obstaclesSegmentedItems)
        segmentedControl.backgroundColor = Constants.defaultBackgroundColor
        segmentedControl.selectedSegmentTintColor = Constants.defaultFontColor
        segmentedControl.layer.borderColor = Constants.defaultBorderColor
        segmentedControl.layer.borderWidth = BorderWidth.borderWidthSegmentedControl
        let titleTextAttributesNormal = [NSAttributedString.Key.foregroundColor: Constants.defaultFontColor]
        segmentedControl.setTitleTextAttributes(titleTextAttributesNormal, for:.normal)
        let titleTextAttributesSelected = [NSAttributedString.Key.foregroundColor: Constants.defaultBackgroundColor]
        segmentedControl.setTitleTextAttributes(titleTextAttributesSelected, for:.selected)
        segmentedControl.addTarget(Any?.self, action: #selector(obstaclesSegmentedValueChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    private let peopleImage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
        configureUI()
        setupBehavior()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        soundPlay.playSound(.soundSettings)
    }
    
    private func setupSubviews() {
        view.addSubview(buttonBack)
        view.addSubview(avatarView)
        view.addSubview(editAvatarButton)
        view.addSubview(userNameTextField)
        view.addSubview(userNameLabel)
        view.addSubview(editUserNameTextFieldButton)
        view.addSubview(saveUserNameTextFieldButton)
        view.addSubview(difficultySegmentedControl)
        view.addSubview(difficultySegmentedLabel)
        view.addSubview(colorDragonSegmentedLabel)
        view.addSubview(colorDragonSegmentedControl)
        view.addSubview(obstaclesSegmentedLabel)
        view.addSubview(obstaclesSegmentedControl)
    }
    private func setupConstraints() {
        buttonBack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.offsetSize.offsetSize56)
            make.left.equalToSuperview().offset(Constants.offsetSize.offsetSize16)
        }
        
        editAvatarButton.snp.makeConstraints { make in
            make.right.equalTo(avatarView)
            make.left.equalTo(avatarView).offset(UIScreen.main.bounds.width / 3 / 2)
            make.bottom.equalTo(avatarView)
            make.leading.equalTo(avatarView)
        }
        userNameTextField.snp.makeConstraints { make in
            make.centerY.equalTo(avatarView)
            make.right.equalToSuperview().offset(-Constants.offsetSize.offsetSize30)
        }
        editUserNameTextFieldButton.snp.makeConstraints { make in
            make.right.equalTo(userNameLabel).offset(editUserNameTextFieldButton.frame.width)
            make.bottom.equalTo(userNameLabel).offset(Offset.offset20)
        }
        saveUserNameTextFieldButton.snp.makeConstraints { make in
            make.right.equalTo(userNameLabel).offset(editUserNameTextFieldButton.frame.width)
            make.bottom.equalTo(userNameLabel).offset(Offset.offset20)
        }
        userNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(avatarView)
            make.right.equalToSuperview().offset(-Constants.offsetSize.offsetSize30)
        }
        difficultySegmentedLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarView).offset(avatarView.frame.height + Offset.offset50)
            make.centerX.equalToSuperview()
        }
        difficultySegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(difficultySegmentedLabel).offset(Constants.offsetSize.offsetSize30)
            make.left.equalToSuperview().offset(Constants.offsetSize.offsetSize30)
            make.centerX.equalToSuperview()
        }
        colorDragonSegmentedLabel.snp.makeConstraints { make in
            make.top.equalTo(difficultySegmentedControl).offset(Offset.offset50)
            make.centerX.equalToSuperview()
        }
        colorDragonSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(colorDragonSegmentedLabel).offset(Constants.offsetSize.offsetSize30)
            make.left.equalToSuperview().offset(Constants.offsetSize.offsetSize30)
            make.centerX.equalToSuperview()
        }
        obstaclesSegmentedLabel.snp.makeConstraints { make in
            make.top.equalTo(colorDragonSegmentedControl).offset(Offset.offset50)
            make.centerX.equalToSuperview()
        }
        obstaclesSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(obstaclesSegmentedLabel).offset(Constants.offsetSize.offsetSize30)
            make.left.equalToSuperview().offset(Constants.offsetSize.offsetSize30)
            make.centerX.equalToSuperview()
        }
    }
    private func configureUI() {
        view.backgroundColor = Constants.defaultBackgroundColor
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    private func setupBehavior() {
        avatarView.image = StorageService.shared.getSavedImage(named: user.userAvatar) ?? UIImage(named: .defaultUserAvatar)
        userNameLabel.text = user.name
        userNameTextField.text = user.name
        colorDragonSegmentedControl.selectedSegmentIndex = user.colorDragonSegmentedValue
        difficultySegmentedControl.selectedSegmentIndex = user.difficultySegmentedValue
        obstaclesSegmentedControl.selectedSegmentIndex = user.obstaclesSegmentedValue
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func saveUserNameAndUserAvatar() {
        let data = avatarView.image?.pngData()
        let nameFilename = "\(userNameLabel.text! + .copyFileName)"
        let filename = getDocumentsDirectory().appendingPathComponent(nameFilename)
        try? data?.write(to: filename)
        user.name = userNameLabel.text ?? .defaultName
        user.userAvatar = nameFilename
    }
    
    @objc private func popSettingsButtonDidTapped() {
        self.navigationController?.popViewController(animated: true)
        saveUserNameAndUserAvatar()
        StorageService.shared.saveUser(user)
    }
    
    @objc private func userNameChange() {
        editUserNameTextFieldButton.isHidden = true
        userNameTextField.isHidden = false
        userNameLabel.isHidden = true
        saveUserNameTextFieldButton.isHidden = false
    }
    
    @objc private func saveUserNameToLable() {
        userNameLabel.text = userNameTextField.text
        editUserNameTextFieldButton.isHidden = false
        userNameTextField.isHidden = true
        userNameLabel.isHidden = false
        saveUserNameTextFieldButton.isHidden = true
    }
   
    @objc func chooseImagePhotoLibrary() {
        imagePicker.showImagePicker(in: self) { [weak self] image in
            self?.avatarView.image = image
        }
    }
    
    @objc func difficultySegmentedValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0 :
            user.difficultyGameSpeed = .speedEasy
            user.difficultyGameIntensity = .intensityEasy
            user.difficultySegmentedValue = 0
        case 1 :
            user.difficultyGameSpeed = .speedMedium
            user.difficultyGameIntensity = .intensityMedium
            user.difficultySegmentedValue = 1
        case 2 :
            user.difficultyGameSpeed = .speedHard
            user.difficultyGameIntensity = .intensityHard
            user.difficultySegmentedValue = 2
        default:
            user.difficultyGameSpeed = .speedMedium
            user.difficultyGameIntensity = .intensityMedium
            user.difficultySegmentedValue = 0
        }
    }
    
    @objc func colorDragonSegmentedValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0 :
            user.colorDragon = .dragonRed
            user.colorDragonSegmentedValue = 0
        case 1 :
            user.colorDragon = .dragonBlue
            user.colorDragonSegmentedValue = 1
        case 2 :
            user.colorDragon = .dragonGreen
            user.colorDragonSegmentedValue = 2
        default:
            user.colorDragon = .dragonRed
            user.colorDragonSegmentedValue = 0
        }
    }
    
    @objc func obstaclesSegmentedValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0 :
            user.typeObstacles = .meteorite
            user.obstaclesSegmentedValue = 0
        case 1 :
            user.typeObstacles = .comet
            user.obstaclesSegmentedValue = 1
        case 2 :
            user.typeObstacles = .asteroid
            user.obstaclesSegmentedValue = 2
        default:
            user.typeObstacles = .meteorite
            user.obstaclesSegmentedValue = 0
        }
    }
    
}

extension SettingsViewController: ISettingsView { }
