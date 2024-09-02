//
//  ForYouTableView.swift
//  iOSPhotos
//
//  Created by Chan on 9/2/24.
//

import UIKit

class ForYouTableView: UITableView {
    var viewModel: ForYouViewModel!
    
    init(viewModel: ForYouViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero, style: .grouped)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTableView()
    }
    
    private func setupTableView() {
        self.dataSource = self
        self.delegate = self
        self.register(ForYouTableViewCell.self, forCellReuseIdentifier: "ForYouTableViewCell")
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.register(ForYouTableViewCell.self, forCellReuseIdentifier: "ForYouTableViewCell")
        self.rowHeight = 200
    }
}

extension ForYouTableView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForYouTableViewCell", for: indexPath) as! ForYouTableViewCell
        cell.configure(with: viewModel, forSection: indexPath.section)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Photos"
        case 1:
            return "Videos"
        default:
            return nil
        }
    }
}
