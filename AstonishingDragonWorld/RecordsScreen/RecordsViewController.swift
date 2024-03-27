//
//  RecordsViewController.swift
//  AstonishingDragonWorld
//
//  Created by Stanislav on 21.02.2024.
//

import UIKit
import SnapKit

protocol IRecordsView: AnyObject { }

private extension String {
    static let textLable = "RECORDS"
    static let forCellReuseIdentifier = "scoreTableViewCell"
    static let soundRecords = "Records"
}

private extension CGFloat {
    static let rowHeight: CGFloat = 100
}

final class RecordsViewController: UIViewController, UITableViewDataSource {
    
    var presenter: IRecordsPresenter!
    // MARK: Private
    private var soundPlay = AVService()
    private var arrayUsersRecords = StorageService.shared.loadUsersRecords() ?? []
    
    private let buttonBack: UIView = {
        let view = UIButton()
        view.setTitle(Constants.backButton, for: .normal)
        view.setTitleColor(Constants.defaultFontColor, for: .normal)
        view.titleLabel?.font = UIFont(name: Constants.defaultFontName, size: Constants.fontSize.fontSize18)
        view.addTarget(Any?.self, action: #selector(popRecordsButtonDidTapped), for: .touchUpInside)
        return view
    }()
    
    private let titleLable: UILabel = {
        let lable = UILabel()
        lable.text = .textLable
        lable.textColor = Constants.defaultFontColor
        lable.font = UIFont(name: Constants.defaultFontName, size: Constants.fontSize.fontSize32)
        return lable
    }()
    
    private let scoreTableView: UITableView = {
        let tableView = UITableView.init(frame: .zero)
        tableView.register(ScoreTableViewCell.self, forCellReuseIdentifier: .forCellReuseIdentifier)
        tableView.backgroundColor = Constants.defaultBackgroundColor
        tableView.rowHeight = .rowHeight
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
        configureUI()
        setupBehavior()
        scoreTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        soundPlay.playSound(.soundRecords)
    }
    
    private func setupSubviews() {
        view.addSubview(scoreTableView)
        view.addSubview(buttonBack)
        view.addSubview(titleLable)
        
    }
    
    private func setupConstraints() {
        buttonBack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.offsetSize.offsetSize56)
            make.left.equalToSuperview().offset(Constants.offsetSize.offsetSize16)
        }
        titleLable.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.offsetSize.offsetSize104)
            make.centerX.equalToSuperview()
        }
        scoreTableView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Constants.offsetSize.offsetSize16)
            make.right.equalToSuperview().offset(-Constants.offsetSize.offsetSize16)
            make.top.equalTo(titleLable).offset(Constants.offsetSize.offsetSize64)
            make.bottom.equalToSuperview().offset(Constants.offsetSize.offsetSize16)
        }
    }
    private func configureUI() {
        view.backgroundColor = Constants.defaultBackgroundColor
        navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    private func setupBehavior() {
        sortedArrrayPoint()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayUsersRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .forCellReuseIdentifier, for: indexPath) as! ScoreTableViewCell
        let scoreUser = arrayUsersRecords[indexPath.row]
        cell.avatarImage.image = StorageService.shared.getSavedImage(named: scoreUser.userAvatar)
        cell.userName.text = scoreUser.name
        cell.scorePiont.text = String(scoreUser.point)
        cell.date.text = scoreUser.date
        cell.backgroundColor = Constants.defaultBackgroundColor
        return cell
    }
    
    private func sortedArrrayPoint() {
        arrayUsersRecords.sort { $0.point > $1.point }
    }
    
    @objc private func popRecordsButtonDidTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension RecordsViewController: IRecordsView { }
