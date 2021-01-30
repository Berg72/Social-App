//
//  HomeController.swift
//  SocialApp
//
//  Created by Mark bergeson on 1/15/21.
//

import UIKit

class HomeController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var datasource = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadDataSource()
    }
    
}

private extension HomeController {
    
    func setupView() {
        view.backgroundColor = .color(.backgroundcolor)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPost))
        addButton.tintColor = .color(.primaryTextColor)
        navigationItem.rightBarButtonItem = addButton
        navigationItem.title = "Home"
        
        tableView.backgroundColor = .color(.backgroundcolor)
        tableView.backgroundView?.backgroundColor = .color(.backgroundcolor)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(FeedTextOnlyCell.self, forCellReuseIdentifier: FeedTextOnlyCell.reuseIdentifier())
        tableView.estimatedRowHeight = 52.0
        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(tableView)
        
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    func loadDataSource() {
        Post.getPost { (posts, error) in
        guard let posts = posts else { return }
            self.datasource.removeAll()
            self.datasource.append(contentsOf: posts)
            self.tableView.reloadData()
            
        }
    }
    
    @objc
    func addNewPost() {
        let vc = ComposeController()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    
}

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ _tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedTextOnlyCell.reuseIdentifier(), for: indexPath)
        
        if let cell = cell as? FeedTextOnlyCell {
            cell.configure(post: datasource[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
