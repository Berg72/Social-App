//
//  ComposeController.swift
//  SocialApp
//
//  Created by Mark bergeson on 1/24/21.
//

import UIKit

class ComposeController: UIViewController {
    
    private let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
}


private extension ComposeController {
    
    func setupView() {
        view.backgroundColor = .color(.backgroundcolor)
        navigationItem.title = "Compsoe Post"
        
        let postButton = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(postButtonAction))
        postButton.tintColor = .color(.primaryTextColor)
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonAction))
        cancelButton.tintColor = .color(.primaryTextColor)
        
        navigationItem.rightBarButtonItem = postButton
        navigationItem.leftBarButtonItem = cancelButton
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        textView.textColor = .color(.primaryTextColor)
        view.addSubview(textView)
        
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14.0).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -14.0).isActive = true
        textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 14.0).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 400.0).isActive = true
        
    }
    
    @objc
    func postButtonAction() {
        guard let text = textView.text, !text.isEmpty else {
            return
        }
        let date = Date().timeIntervalSince1970
        
        let post = Post(id: nil, authorImgUrl: nil, authorName: "Mark", text: text, commentCount: 0, visibleToPublic: false, approvedBy: nil, DeniedBy: nil, moderated: false, reportedBy: [String](), created: date, createdBy: "test", lastUpdated: date, lastUpdatedBy: "test", archived: false, archivedAt: nil)
        
        Database.shared.save(post) { (post, error) in
            guard let error = error else {
                self.dismiss(animated: true, completion: nil)
                return
            }
            print(error)
        }
    }
    
    @objc
    func cancelButtonAction() {
        dismiss(animated: true, completion: nil)
    }
    
}
