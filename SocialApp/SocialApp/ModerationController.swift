//
//  ModerationController.swift
//  SocialApp
//
//  Created by Mark bergeson on 1/31/21.
//

import UIKit

class ModerationController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var datasource = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadDataSource()
    }
}


private extension ModerationController {
    func setupView() {
        view.backgroundColor = .color(.backgroundcolor)
        
        navigationItem.title = "Moderation"
        
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
        Post.getPostModerate { (posts, error) in
            guard let posts = posts else { return }
            self.datasource.removeAll()
            self.datasource.append(contentsOf: posts)
            self.datasource.sort(by: { $0.created < $1.created })
            self.tableView.reloadData()
                
        }
        
    }
    
    func displayMoreOptions(post: Post) {
        var post = post
        let alert = UIAlertController(title: "Moderation Options", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Approve", style: .default, handler: { (action) in
            post.approvedBy = Database.shared.currentUser?.id
            post.visibleToPublic = true
            post.moderated = true
            
            Database.shared.save(post) { (post, error) in
                self.loadDataSource()
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Deny", style: .default, handler: { (action) in
            post.moderated = true
            post.deniedBy = Database.shared.currentUser?.id
            
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
    
//    func sharePost(post: Post) {
//
//    }
    
}

extension ModerationController: UITableViewDelegate, UITableViewDataSource {
    
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
                
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

