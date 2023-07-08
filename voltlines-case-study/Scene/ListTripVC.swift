//
//  ListTripVC.swift
//  voltlines-case-study
//
//  Created by Ali Beyaz on 7.07.2023.
//

import UIKit
import SnapKit

class ListTripVC: UIViewController {
    let tableView = UITableView()
    var data: [String] = ["Bus 1", "Bus 2", "Bus 3"]
    
    override func viewDidLoad() {
        setupUI()
        super.viewDidLoad()
    }
    
    func setupUI(){
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.register(ListTripTableViewCell.self, forCellReuseIdentifier: "CustomTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
    }
}

extension ListTripVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBus = data[indexPath.row]
        print("Selected bus: \(selectedBus)")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? ListTripTableViewCell else {
            return UITableViewCell()
        }
        
        let busName = data[indexPath.row]
        cell.busNameLabel.text = busName
        cell.timeLabel.text = "10:00 AM"
        cell.bookButton.setTitle("Book", for: .normal)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
}
