//
//  PostDetailsController.swift
//  SocialApp
//
//  Created by Mark bergeson on 2/20/21.
//

import UIKit

class PostDetailsController: UIViewController {


    private let tableView = UITableView(frame: .zero, style: .plain)
    private var post: Post
    
    init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    
    }
    
}

    private extension PostDetailsController {
        
        func setupView() {
            view.backgroundColor = .color(.backgroundcolor)
            
            navigationController?.navigationBar.tintColor = .color(.primaryTextColor)
            
            navigationItem.title = "Post Details"
            
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
        
        
        func displayMoreOptions(post: Post) {
//            var post = post
//            let alert = UIAlertController(title: "Post Options", message: nil, preferredStyle: .actionSheet)
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//            alert.addAction(UIAlertAction(title: "I don't want to see this", style: .default, handler: { (action) in
//                guard let userId = Database.shared.currentUser?.id else { return }
//                post.reportedBy.append(userId)
//
//                Database.shared.save(post) { (post, error) in
//                    self.loadDataSource()
//                }
//
//            }))
//            // for Ipad only
//            if let popoverController = alert.popoverPresentationController {
//                popoverController.sourceView = self.view
//                popoverController.sourceRect = CGRect(x: self.view.bounds.minX, y: self.view.bounds.midY, width: 0, height: 0)
//            }
            
//            present(alert, animated: true, completion: nil)

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

    extension PostDetailsController: UITableViewDelegate, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, section: Int) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
        func tableView(_ _tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: FeedTextOnlyCell.reuseIdentifier(), for: indexPath)
            
            if let cell = cell as? FeedTextOnlyCell {
                cell.configure(post: post, details: true) {
                    self.displayMoreOptions(post: self.post)
                    } shareButtonAction: {
                        self.sharePost(post: self.post)
                    
                }
            }
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

  

