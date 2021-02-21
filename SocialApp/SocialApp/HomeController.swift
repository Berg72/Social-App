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
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .color(.primaryTextColor)
        control.addTarget(self, action: #selector(loadDataSource), for: .valueChanged)
        control.attributedTitle = NSAttributedString(string: "Loading Posts...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.color(.primaryTextColor)])
        return control
    }()
    
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
        
        if let role = Database.shared.currentUser?.role {
            if role == .admin {
                let moderationButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(moderationButtonAction))
                moderationButton.tintColor = .color(.primaryTextColor)
                navigationItem.rightBarButtonItems = [addButton, moderationButton]
            } else {
                navigationItem.rightBarButtonItem = addButton
            }
        } else {
            navigationItem.rightBarButtonItem = addButton
        }
        
        
        navigationController?.navigationBar.tintColor = .color(.primaryTextColor)
        
        
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
        tableView.refreshControl = refreshControl
        view.addSubview(tableView)
        
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
    @objc
    func loadDataSource() {
        Post.getPost { (posts, error) in
        guard let posts = posts else { return }
            self.datasource.removeAll()
            self.datasource.append(contentsOf: posts)
            if let userId = Database.shared.currentUser?.id {
                self.datasource = self.datasource.filter({ !$0.reportedBy.contains(userId) })
            }
            self.datasource.sort(by: { $0.created > $1.created })
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            
        }
    }
    
    @objc
    func addNewPost() {
        let vc = ComposeController()
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    @objc
    func moderationButtonAction() {
        let vc = ModerationController()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func displayMoreOptions(post: Post) {
        var post = post
        let alert = UIAlertController(title: "Post Options", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "I don't want to see this", style: .default, handler: { (action) in
            guard let userId = Database.shared.currentUser?.id else { return }
            post.reportedBy.append(userId)
            
            Database.shared.save(post) { (post, error) in
                self.loadDataSource()
            }
            
        }))
        // for Ipad only
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.minX, y: self.view.bounds.midY, width: 0, height: 0)
        }
        
        present(alert, animated: true, completion: nil)

    }
    
    func sharePost(post: Post) {
        let items = [post.text]
        let alert = UIActivityViewController(activityItems: items, applicationActivities: nil)
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.minX, y: self.view.bounds.midY, width: 0, height: 0)
        }
        present(alert, animated: true)
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
            cell.configure(post: datasource[indexPath.row]) {
                self.displayMoreOptions(post: self.datasource[indexPath.row])
                } shareButtonAction: {
                    self.sharePost(post: self.datasource[indexPath.row])
                
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let post = datasource[indexPath.row]
        let vc = PostDetailsController(post: post)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeController: ComposeControllerDelegate {
    func creadtedNewPost() {
        loadDataSource()
    }
}
