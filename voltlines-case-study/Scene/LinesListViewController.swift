//
//  LinesListViewController.swift
//  VoltLinesChallenge
//
//  Created by Ali Beyaz on 8.07.2023.
//

protocol LinesListViewControllerDelegate: AnyObject {
    func didBookedTrip(_ id: Int)
}

import UIKit

class LinesListViewController: VoltLinesViewController {
    
    var manager: LinesListManager = { () in
            .init()
    }()
    
    let tvList: UITableView = {
        let tbl = UITableView()
        tbl.backgroundColor = .white
        tbl.separatorStyle = .none
        tbl.showsVerticalScrollIndicator = true
        return tbl
    }()
    
    var routeId = Int()
    var line = MapStation()
    weak var delegate: LinesListViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        initManager()
    }
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(tvList)
        setTitle()
        
        tvList.delegate = self
        tvList.dataSource = self
        tvList.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tvList.registerCellWithoutNib(LineItemCell.self)
        tvList.registerCellWithoutNib(ListLineCell.self)
        tvList.registerCellWithoutNib(LinesListSpacingCell.self)
    }
    
    private func setTitle() {
        let titleItem = UIBarButtonItem(title: "Trips", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = titleItem
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20),
            .foregroundColor: UIColor.mainBottomColor
        ]
        navigationController?.navigationBar.titleTextAttributes = attributes
    }
    
    func initManager() {
        manager.selectedTrips = line
        manager.generateTripList()
        
        manager.didListUpdated = {
            DispatchQueue.main.async {
                self.tvList.reloadData()
            }
        }
        
        manager.didBookedTrip = { id in
            self.delegate?.didBookedTrip(id)
            self.dismiss(animated: true)
        }
        
        manager.didFailedBookTrip = {
            GenericAlertDialogUtils.shared.showAlert()
        }
    }
}

extension LinesListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.manager.sectionListSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.manager.rowCount(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.manager.sectionListSource[indexPath.section]
        switch data.type {
        case .line:
            return ListLineCell.createCell(data, tableView: tableView, indexPath: indexPath)
        case .spacing:
            return LinesListSpacingCell.createCell(data, tableView: tableView, indexPath: indexPath)
        case .route:
            return LineItemCell.createCell(data, tableView: tableView, indexPath: indexPath, delegate: self)
        }
    }
}

extension LinesListViewController: LineItemCellDelegate {
    func didTappedLineBook(_ id: Int) {
        self.manager.bookSelectedTrip(id)
    }
}

