//
//  ComposeController.swift
//  SocialApp
//
//  Created by Mark bergeson on 1/24/21.
//

import UIKit
import PhotosUI
import FirebaseStorage
import SDWebImage

protocol ComposeControllerDelegate: AnyObject {
    func creadtedNewPost()
}

class ComposeController: UIViewController {
    
    weak var delegate: ComposeControllerDelegate?
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var mediaViewBottomAnchor: NSLayoutConstraint?
    private var postText: String?
    private var images = [UIImage]()
    
    @available(iOS 14, *)
    private lazy var photoController: PHPickerViewController = {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 10
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        return picker
    }()
    
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let timeLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

private extension ComposeController {
    
    func setupView() {
        view.backgroundColor = .white
        navigationItem.title = "Compose Post"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppeared(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        let postButton = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(postButtonAction))
        postButton.tintColor = .color(.primaryTextColor)
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonAction))
        cancelButton.tintColor = .color(.primaryTextColor)
        
        navigationItem.rightBarButtonItem = postButton
        navigationItem.leftBarButtonItem = cancelButton
        
        let profileContainer = UIView()
        profileContainer.translatesAutoresizingMaskIntoConstraints = false
        profileContainer.backgroundColor = .white
        view.addSubview(profileContainer)
        
        profileContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0.0).isActive = true
        profileContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        profileContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
        profileContainer.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 23.0
        profileImageView.layer.masksToBounds = true
        profileContainer.addSubview(profileImageView)
        
        profileImageView.topAnchor.constraint(equalTo: profileContainer.topAnchor,constant: 14.0).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: profileContainer.leadingAnchor,constant: 14.0).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 46.0).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 46.0).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        nameLabel.textColor = .color(.primaryTextColor)
        profileContainer.addSubview(nameLabel)
        
        nameLabel.topAnchor.constraint(equalTo: profileContainer.topAnchor,constant: 16.0).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor,constant: 14.0).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: profileContainer.trailingAnchor, constant: -60.0).isActive = true
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        timeLabel.textColor = UIColor.color(.primaryTextColor).withAlphaComponent(0.40)
        profileContainer.addSubview(timeLabel)
        
        timeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant: 4.0).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor,constant: 14.0).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: profileContainer.trailingAnchor, constant: -60.0).isActive = true
        
        if let urlString = Database.shared.currentUser?.profileImageUrl {
            profileImageView.sd_setImage(with: URL(string: urlString), placeholderImage: nil)
        } else {
            profileImageView.image = UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysTemplate)
            profileImageView.tintColor = .lightGray
        }
        
        nameLabel.text = Database.shared.currentUser?.name
        timeLabel.text = "Now"
        
        let mediaContainer = UIView()
        mediaContainer.translatesAutoresizingMaskIntoConstraints = false
        mediaContainer.backgroundColor = .white
        mediaContainer.layer.applySketchShadow(color: .color(.shadowColor), alpha: 1.0, x: 0.0, y: -2.0, blur: 4.0, spread: 0.0)
        mediaContainer.layer.cornerRadius = 6.0
        view.addSubview(mediaContainer)
        
        mediaContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mediaContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mediaContainer.heightAnchor.constraint(equalToConstant: 48.0).isActive = true
        mediaViewBottomAnchor = mediaContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        mediaViewBottomAnchor?.isActive = true
        
        let mediaButton = UIButton(type: .roundedRect)
        mediaButton.translatesAutoresizingMaskIntoConstraints = false
        mediaButton.setImage(UIImage(systemName: "photo")?.withRenderingMode(.alwaysTemplate), for: .normal)
        mediaButton.tintColor = .color(.primaryTextColor)
        if #available(iOS 14, *) {
            mediaButton.addTarget(self, action: #selector(addMediaButtonAction), for: .touchUpInside)
            mediaContainer.addSubview(mediaButton)
            
            mediaButton.leadingAnchor.constraint(equalTo: mediaContainer.leadingAnchor).isActive = true
            mediaButton.topAnchor.constraint(equalTo: mediaContainer.topAnchor).isActive = true
            mediaButton.heightAnchor.constraint(equalToConstant: 48.0).isActive = true
            mediaButton.widthAnchor.constraint(equalToConstant: 48.0).isActive = true
        } else {
            // Fallback on earlier versions
        }
        
        tableView.backgroundColor = .white
        tableView.backgroundView?.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(ComposeTextEntryCell.self, forCellReuseIdentifier: ComposeTextEntryCell.reuseIdentifier())
        tableView.register(ComposeImagesCell.self, forCellReuseIdentifier: ComposeImagesCell.reuseIdentifier())
        tableView.estimatedRowHeight = 52.0
        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: profileContainer.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: mediaContainer.topAnchor, constant: -8.0).isActive = true
        
    }
    
    @objc
    func postButtonAction() {
        guard let text = postText, !text.isEmpty else {
            return
        }
        
        guard let user = Database.shared.currentUser, let userId = user.id else {
            return
        }
        
        // handle images.
        let group = DispatchGroup()
        var imageUrls = [String]()
        for image in images {
            group.enter()
            uploadImage(image: image) { (urlString) in
                if let url = urlString {
                    imageUrls.append(url)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            let date = Date().timeIntervalSince1970
            
            let urls = imageUrls.isEmpty ? nil : imageUrls
            
            let post = Post(id: nil, authorImgUrl: user.profileImageUrl, authorName: user.name, text: text, commentCount: 0, visibleToPublic: false, approvedBy: nil, deniedBy: nil, moderated: false, reportedBy: [String](), imageUrls: urls, created: date, createdBy: userId, lastUpdated: date, lastUpdatedBy: userId, archived: false, archivedAt: nil)
            
            Database.shared.save(post) { (post, error) in
                guard let error = error else {
                    self.delegate?.creadtedNewPost()
                    self.dismiss(animated: true, completion: nil)
                    return
                }
                print(error)
            }
        }
    }
    func uploadImage(image: UIImage, oncomplete: @escaping (_ urlString: String?) -> ()) {
        var data: Data?
        if let d = image.jpegData(compressionQuality: 0.9), d.count < 100000 {
            data = d
        } else if let d = image.jpegData(compressionQuality: 0.8), d.count < 60000 {
            data = d
        } else if let d = image.jpegData(compressionQuality: 0.7), d.count < 60000 {
            data = d
        } else if let d = image.jpegData(compressionQuality: 0.6), d.count < 60000 {
            data = d
        } else if let d = image.jpegData(compressionQuality: 0.5), d.count < 60000 {
            data = d
        } else if let d = image.jpegData(compressionQuality: 0.4), d.count < 60000 {
            data = d
        } else if let d = image.jpegData(compressionQuality: 0.3), d.count < 60000 {
            data = d
        } else {
            data = image.jpegData(compressionQuality: 1.0)
        }
        
        guard let dataToStore = data else {
            oncomplete(nil)
            return
        }
        let ident = UUID().uuidString
        
        let ref = Storage.storage().reference(withPath: "PostImages").child("images/\(ident).jpg")

        // Upload the file to the path "images/rivers.jpg"
        ref.putData(dataToStore, metadata: nil) { (metadata, error) in
            ref.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    oncomplete(nil)
                    return
                }
                oncomplete(downloadURL.absoluteString)
            }
        }
    }
    
    @objc
    func cancelButtonAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @available(iOS 14, *)
    @objc
    func addMediaButtonAction() {
        if PHPhotoLibrary.authorizationStatus() != .authorized || PHPhotoLibrary.authorizationStatus() != .limited {
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized || status == .limited {
                    DispatchQueue.main.async {
                        self.present(self.photoController, animated: true, completion: nil)
                    }
                }
            }
        } else {
                present(photoController, animated: true, completion: nil)
            }
        }
        
}

extension ComposeController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !images.isEmpty {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComposeTextEntryCell.reuseIdentifier(), for: indexPath)
            
            if let cell = cell as? ComposeTextEntryCell {
                cell.configure(text: postText, tableView: tableView) { (text) in
                    self.postText = text
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComposeImagesCell.reuseIdentifier(), for:  indexPath)
            if let cell = cell as? ComposeImagesCell {
                cell.configure(images: images) { (index) in
                    self.images.remove(at: index)
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
            return cell
        }
    }

}

private extension ComposeController {
    
    @objc func keyboardAppeared(notification: Notification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let anitmationCurveRaw = animationCurveRawNSN?.uintValue ??
                UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: anitmationCurveRaw)
            
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.mediaViewBottomAnchor?.constant = 0.0
            } else {
                let offset = UIScreen.main.bounds.size.height - endFrameY
                self.mediaViewBottomAnchor?.constant = -offset + view.safeAreaInsets.bottom
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations:  { self.view.layoutIfNeeded() },
                           completion:  nil)
                           
        }
    }

}
        @available(iOS 14, *)
        extension ComposeController: PHPickerViewControllerDelegate {
            
            func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
                guard !results.isEmpty else {
                    picker.dismiss(animated: true, completion: nil)
                    return
                }
                
                var count = 0
                for result in results {
                    guard result.itemProvider.canLoadObject(ofClass: UIImage.self) else {
                        if count == results.count {
                            tableView.reloadData()
                            picker.dismiss(animated: true, completion: nil)
                        }
                        continue
                    }
                    result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                        DispatchQueue.main.async {
                            if let image = image as? UIImage {
                                self?.images.append(image)
                            } else {
                                
                                // was probably an error...
                            }
                            count += 1
                            if count == results.count {
                                self?.tableView.reloadData()
                                picker.dismiss(animated: true, completion: nil)
                                
                            }
                            
                        }
                            
                    }
                }
                
            }
}

