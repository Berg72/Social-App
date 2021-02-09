//
//  ComposeController.swift
//  SocialApp
//
//  Created by Mark bergeson on 1/24/21.
//

import UIKit

protocol ComposeControllerDelegate: AnyObject {
    func creadtedNewPost()
}

class ComposeController: UIViewController {
    
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let timeLabel = UILabel()
    
    weak var delegate: ComposeControllerDelegate?
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
        view.backgroundColor = .white
        navigationItem.title = "Compsoe Post"
        
        let postButton = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(postButtonAction))
        postButton.tintColor = .color(.primaryTextColor)
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonAction))
        cancelButton.tintColor = .color(.primaryTextColor)
        
        navigationItem.rightBarButtonItem = postButton
        navigationItem.leftBarButtonItem = cancelButton
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 23.0
        profileImageView.layer.masksToBounds = true
        view.addSubview(profileImageView)
        
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 14.0).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 14.0).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 46.0).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 46.0).isActive = true
        
        
//        containerView.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        nameLabel.textColor = .color(.primaryTextColor)
        view.addSubview(nameLabel)
        
        nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 16.0).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor,constant: 14.0).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60.0).isActive = true
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        timeLabel.textColor = UIColor.color(.primaryTextColor).withAlphaComponent(0.40)
        view.addSubview(timeLabel)
        
        timeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant: 4.0).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor,constant: 14.0).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60.0).isActive = true
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        textView.textColor = .color(.primaryTextColor)
        view.addSubview(textView)
        
        profileImageView.image = UIImage(named: "profile-image")
        nameLabel.text = Database.shared.currentUser?.name
        timeLabel.text = "Now"
        
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14.0).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -14.0).isActive = true
        textView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor,constant: 14.0).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 400.0).isActive = true
        
    }
    
    @objc
    func postButtonAction() {
        guard let text = textView.text, !text.isEmpty else {
            return
        }
        
        guard let user = Database.shared.currentUser, let userId = user.id else {
            return
        }
        
        let date = Date().timeIntervalSince1970
        
        let post = Post(id: nil, authorImgUrl: user.profileImageUrl, authorName: user.name, text: text, commentCount: 0, visibleToPublic: false, approvedBy: nil, deniedBy: nil, moderated: false, reportedBy: [String](), created: date, createdBy: userId, lastUpdated: date, lastUpdatedBy: userId, archived: false, archivedAt: nil)
        
        Database.shared.save(post) { (post, error) in
            guard let error = error else {
                self.delegate?.creadtedNewPost()
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
