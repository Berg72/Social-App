//
//  AlertsController.swift
//  SocialApp
//
//  Created by Mark bergeson on 2/16/21.
//

import UIKit

class AlertsController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var datasource = [Alert]()
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .color(.primaryTextColor)
        control.addTarget(self, action: #selector(loadDataSource), for: .valueChanged)
        control.attributedTitle = NSAttributedString(string: "Loading Alerts...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.color(.primaryTextColor)])
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadDataSource()
    }
}

private extension AlertsController {
    
    func setupView() {
        view.backgroundColor = .color(.backgroundcolor)
        navigationController?.navigationBar.tintColor = .color(.primaryTextColor)
        
        navigationItem.title = "Alerts"
        
        tableView.backgroundColor = .color(.backgroundcolor)
        tableView.backgroundView?.backgroundColor = .color(.backgroundcolor)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(AlertCell.self, forCellReuseIdentifier: AlertCell.reuseIdentifier())
        tableView.estimatedRowHeight = 52.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.refreshControl = refreshControl
        view.addSubview(tableView)
        
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    @objc
    func loadDataSource() {
        datasource.removeAll()
        Alert.getAlerts { (alerts, error) in 
            guard let alerts = alerts else {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                return
            }
            
            guard let userId = Database.shared.currentUser?.id else { return }
            let filteredAlerts = alerts.filter({ $0.createdBy != userId })
            
            self.datasource.append(contentsOf: alerts)
            self.datasource.sort(by: { $0.created > $1.created })
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
}

extension AlertsController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlertCell.reuseIdentifier(), for: indexPath)
        cell.selectionStyle = .none
        if let cell = cell as? AlertCell {
            cell.configure(alert: datasource[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let postId = datasource[indexPath.row].postid, let alertId = datasource[indexPath.row].id else { return }
        Post.getPost(postId: postId) { (post, error) in
            guard let post = post else { return }
            UserDefaults.standard.setValue(true, forKey: alertId)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            let vc = PostDetailsController(post: post)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
