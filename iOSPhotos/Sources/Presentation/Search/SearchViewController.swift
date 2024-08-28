//
//  SearchViewController.swift
//  iOSPhotos
//
//  Created by Chan on 8/27/24.
//

import UIKit

final class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    var searchSections: [SearchSection] = []
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        loadInitialData()
        setupSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SpecialMomentCell.self, forCellReuseIdentifier: "SpecialMomentCell")
        tableView.register(PersonCell.self, forCellReuseIdentifier: "PersonCell")
        tableView.register(CategoryGroupCell.self, forCellReuseIdentifier: "CategoryGroupCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func setupSearchController() {
        searchController = SearchController()
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "Search"
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch searchSections[section] {
        case .specialMoments(let moments):
            return moments.count
        case .people(let people):
            return people.count
        case .categoryGroups(let categories):
            return categories.count
        case .recentSearches(let searches):
            return searches.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = searchSections[indexPath.section]
        
        switch section {
        case .specialMoments(let moments):
            let cell = tableView.dequeueReusableCell(withIdentifier: "SpecialMomentCell", for: indexPath) as! SpecialMomentCell
            cell.configure(with: moments[indexPath.row])
            return cell
        case .people(let people):
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as! PersonCell
            cell.configure(with: people[indexPath.row])
            return cell
        case .categoryGroups(let categories):
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryGroupCell", for: indexPath) as! CategoryGroupCell
            cell.configure(with: categories[indexPath.row])
            return cell
        case .recentSearches(let searches):
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
            cell.textLabel?.text = searches[indexPath.row]
            return cell
        }
    }
}

extension SearchViewController {
    func loadInitialData() {
        // 목업 데이터 생성
        let moments = [
            Moment(title: "Birthday Party", images: [UIImage(named: "image1") ?? UIImage(systemName: "photo")!]),
            Moment(title: "Vacation", images: [UIImage(named: "image2") ?? UIImage(systemName: "photo")!])
        ]
        let people = [
            Person(name: "John Doe", photo: UIImage(named: "person1") ?? UIImage(systemName: "person.circle")!),
            Person(name: "Jane Smith", photo: UIImage(named: "person2") ?? UIImage(systemName: "person.circle")!)
        ]
        let categories = [
            Category(name: "Nature", items: ["Mountains", "Rivers"]),
            Category(name: "Cities", items: ["New York", "Paris"])
        ]
        let searches = ["Sunset", "Hiking"]
        
        // 섹션별 데이터 추가
        searchSections = [
            .specialMoments(moments),
            .people(people),
            .categoryGroups(categories),
            .recentSearches(searches)
        ]
        tableView.reloadData()
    }
}

// Special Moment Cell
class SpecialMomentCell: UITableViewCell {
    func configure(with moment: Moment) {
        textLabel?.text = moment.title
        // Optionally add an image view and set it
        imageView?.image = moment.images.first
    }
}

// Person Cell
class PersonCell: UITableViewCell {
    func configure(with person: Person) {
        textLabel?.text = person.name
        imageView?.image = person.photo
    }
}

// Category Group Cell
class CategoryGroupCell: UITableViewCell {
    func configure(with category: Category) {
        textLabel?.text = category.name
    }
}
