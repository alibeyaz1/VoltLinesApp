//
//  LinesListViewController.swift
//  VoltLinesChallenge
//
//  Created by Ali Beyaz on 8.07.2023.
//

import UIKit

// Delegate protocol for communication with the delegate object
protocol LinesListViewControllerDelegate: AnyObject {
    func didBookedTrip(_ id: Int)
}

class LinesListViewController: VoltLinesViewController {
    
    // Manager responsible for managing the list of lines/trips
    var manager: LinesListManager = { () in
        .init()
    }()
    
    // TableView to display the list of trips
    let tripsTableView = UITableView()
    
    // Properties for route ID, line, and delegate
    var routeId = Int()
    var line = MapStation()
    weak var delegate: LinesListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        initManager()
    }
    
    // Configure the view appearance and add subviews
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(tripsTableView)
        setTitle()
        
        tripsTableView.backgroundColor = .white
        tripsTableView.separatorStyle = .none
        tripsTableView.showsVerticalScrollIndicator = true
        tripsTableView.delegate = self
        tripsTableView.dataSource = self
        tripsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tripsTableView.registerCellWithoutNib(LineItemCell.self)
    }
    
    // Set the title for the navigation bar
    private func setTitle() {
        let titleItem = UIBarButtonItem(title: "Trips", style: .plain, target: self, action: #selector(titleItemTapped))
        navigationItem.leftBarButtonItem = titleItem
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 24),
            .foregroundColor: UIColor.black
        ]
        navigationController?.navigationBar.titleTextAttributes = attributes
    }
    
    @objc private func titleItemTapped() {
   
        let viewController = MapViewController() 
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // Initialize the manager and set up callbacks
    func initManager() {
        manager.selectedTrips = line
        manager.generateTripList()
        
        manager.didListUpdated = {
            DispatchQueue.main.async {
                self.tripsTableView.reloadData()
            }
        }
        
        manager.didBookedTrip = { id in
            self.delegate?.didBookedTrip(id)
            self.dismiss(animated: true)
        }
        
        manager.didFailedBookTrip = {
            let alert = UIAlertController(title: "The trip you selected is full", message: "Please select another one", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Select a Trip", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension LinesListViewController: UITableViewDelegate, UITableViewDataSource {
    // Number of sections in the TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.manager.sectionListSource.count
    }
    
    // Number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.manager.rowCount(section)
    }
    
    // Create and configure each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.manager.sectionListSource[indexPath.section]
        return LineItemCell.createCell(data, tableView: tableView, indexPath: indexPath, delegate: self)
    }
}

extension LinesListViewController: LineItemCellDelegate {
    // Handle the book button tap event from a LineItemCell
    func didTappedLineBook(_ id: Int) {
        self.manager.bookSelectedTrip(id)
    }
}
