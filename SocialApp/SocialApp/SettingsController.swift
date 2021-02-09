//
//  SettingsController.swift
//  SocialApp
//
//  Created by Mark bergeson on 2/7/21.
//

import UIKit

class SettingsController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var datasource = [SettingRow]()
    
    enum SettingRow: String {
        case terms = "Terms & Conditions"
        case privacy = "Privacy Policy"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadDatasource()
    }
}


private extension SettingsController {
    
    func setupView() {
        view.backgroundColor = .white
        
        navigationItem.title = "Settings"
        navigationController?.navigationBar.tintColor = .color(.primaryTextColor)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonAction))
        
        tableView.backgroundColor = .white
        tableView.backgroundView?.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier())
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func loadDatasource() {
        datasource.append(.privacy)
        datasource.append(.terms)
        tableView.reloadData()
    }
    
    @objc
    func closeButtonAction() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension SettingsController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier(),for: indexPath)
        cell.textLabel?.text = datasource[indexPath.row].rawValue
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = datasource[indexPath.row]
        let url: URL
        switch row {
        case .privacy:
            guard let aUrl = URL(string: "https://social-app-37fb9.web.app/privacy.html") else { return }
            url = aUrl
        case .terms:
            guard let aUrl = URL(string: "https://social-app-37fb9.web.app/terms.html") else { return }
            url = aUrl
        }
        let vc = WebController(url: url)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
