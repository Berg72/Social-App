//
//  ProfileController.swift
//  SocialApp
//
//  Created by Mark bergeson on 1/31/21.
//

import UIKit
import PhotosUI
import FirebaseStorage
import SDWebImage

class ProfileController: UIViewController {
    
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    @available(iOS 14, *)
    private lazy var photoController: PHPickerViewController = {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
}

private extension ProfileController {
    
    
    func setupView() {
        view.backgroundColor = .color(.backgroundcolor)
        navigationItem.title = "Profile"
        
        let settingsImage = UIImage(systemName: "gear")
        
        let settingsButton = UIBarButtonItem(image: settingsImage, style: .plain, target: self, action: #selector(settingsButtonAction))
        navigationItem.rightBarButtonItem = settingsButton
        navigationController?.navigationBar.tintColor = .color(.primaryTextColor)
        
        let imgBackgroundView = UIView()
        imgBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        imgBackgroundView.backgroundColor = .color(.primaryTextColor)
        view.addSubview(imgBackgroundView)
        
        imgBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        imgBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imgBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imgBackgroundView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        let lightImgBackgroundView = UIView()
        lightImgBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        lightImgBackgroundView.backgroundColor = .white
        lightImgBackgroundView.layer.cornerRadius = 180.0 / 2.0
        lightImgBackgroundView.layer.borderWidth = 6.0
        lightImgBackgroundView.layer.borderColor = UIColor.white.cgColor
        imgBackgroundView.addSubview(lightImgBackgroundView)
        
        lightImgBackgroundView.centerXAnchor.constraint(equalTo: imgBackgroundView.centerXAnchor).isActive = true
        lightImgBackgroundView.widthAnchor.constraint(equalToConstant: 180.0).isActive = true
        lightImgBackgroundView.heightAnchor.constraint(equalToConstant: 180.0).isActive = true
        lightImgBackgroundView.topAnchor.constraint(equalTo: imgBackgroundView.topAnchor, constant: 78.0).isActive = true
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.backgroundColor = .color(.primaryTextColor)
        profileImageView.layer.cornerRadius = 180.0 / 2.0
        profileImageView.layer.masksToBounds = true
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        
        
        if let urlString = Database.shared.currentUser?.profileImageUrl {
            profileImageView.sd_setImage(with: URL(string: urlString), placeholderImage: nil)
        } else {
            profileImageView.image = UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysTemplate)
        }
        
        
        profileImageView.tintColor = .lightGray
        lightImgBackgroundView.addSubview(profileImageView)
        
        profileImageView.centerYAnchor.constraint(equalTo: lightImgBackgroundView.centerYAnchor).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: lightImgBackgroundView.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 180.0).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 180.0).isActive = true
        
        let editImgOverlay = UIView()
        editImgOverlay.translatesAutoresizingMaskIntoConstraints = false
        editImgOverlay.backgroundColor = UIColor.color(.primaryTextColor).withAlphaComponent(0.5)
        lightImgBackgroundView.addSubview(editImgOverlay)
        
        editImgOverlay.leadingAnchor.constraint(equalTo: lightImgBackgroundView.leadingAnchor).isActive = true
        editImgOverlay.trailingAnchor.constraint(equalTo: lightImgBackgroundView.trailingAnchor).isActive = true
        editImgOverlay.bottomAnchor.constraint(equalTo: lightImgBackgroundView.bottomAnchor).isActive = true
        editImgOverlay.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        
        let editImgButton = UIButton(type: .roundedRect)
        editImgButton.translatesAutoresizingMaskIntoConstraints = false
        editImgButton.setImage(UIImage(systemName: "camera"), for: .normal)
        editImgButton.tintColor = .white
        
        
        if #available(iOS 14, *) {
            editImgButton.addTarget(self, action: #selector(editImgButtonAction), for: .touchUpInside)
        } else {
            // Fallback on earlier versions
        }
        editImgOverlay.addSubview(editImgButton)
        
        editImgButton.centerYAnchor.constraint(equalTo: editImgOverlay.centerYAnchor, constant: -7.0).isActive = true
        editImgButton.centerXAnchor.constraint(equalTo: editImgOverlay.centerXAnchor).isActive = true
        editImgButton.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        editImgButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 24.0, weight: .bold)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .white
        nameLabel.text = Database.shared.currentUser?.name
        imgBackgroundView.addSubview(nameLabel)
        
        nameLabel.topAnchor.constraint(equalTo: lightImgBackgroundView.bottomAnchor, constant: 20.0).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: imgBackgroundView.centerXAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 29.0).isActive = true
        
        let editButton = UIButton(type: .roundedRect)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.setImage(UIImage(named: "edit-image")?.withRenderingMode(.alwaysOriginal), for: .normal)
        editButton.addTarget(self, action: #selector(editNameButtonAction), for: .touchUpInside)
        imgBackgroundView.addSubview(editButton)
        
        editButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
        editButton.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: 43.0).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 43.0).isActive = true
        
    }
    
    @objc
    func settingsButtonAction() {
        let vc = SettingsController()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    @objc
    func editNameButtonAction() {
        let alert = UIAlertController(title: "Edit name", message: nil, preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Enter name..."
            textfield.text = Database.shared.currentUser?.name
            textfield.textContentType = .givenName
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            
        }))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            guard let text = alert.textFields?.first?.text, !text.isEmpty else { return }
            guard var user = Database.shared.currentUser else { return }
            user.name = text
            
            Database.shared.save(user) { (user, error) in
                guard let user = user else { return }
                Database.shared.currentUser = user
                self.nameLabel.text = Database.shared.currentUser?.name
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @available(iOS 14, *)
    @objc
    func editImgButtonAction() {
        if PHPhotoLibrary.authorizationStatus() != .authorized || PHPhotoLibrary.authorizationStatus() != .limited {
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized || status == .limited {
                    DispatchQueue.main.async {
                        self.present(self.photoController, animated: true, completion: nil)
                    }
                }
            }
        }
        present(photoController, animated: true, completion: nil)
    }
    
}

@available(iOS 14, *)
extension ProfileController:PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self)
            { [weak self] image, error in
                DispatchQueue.main.async {
                    picker.dismiss(animated: true, completion: nil)
                    guard let self = self else { return }
                    if let image = image as? UIImage {
                        self.profileImageView.image = image
                        
                        
                        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
                        let ident = UUID().uuidString

                        
                        let ref = Storage.storage().reference(withPath: "ProfileImages").child("images/\(ident).jpg")

                        // Upload the file to the path "images/rivers.jpg"
                        let uploadTask = ref.putData(data, metadata: nil) { (metadata, error) in
                          guard let metadata = metadata else {
                            // Uh-oh, an error occurred!
                            return
                          }
                          // Metadata contains file metadata such as size, content-type.
                          let size = metadata.size
                          // You can also access to download URL after upload.
                          ref.downloadURL { (url, error) in
                            guard let downloadURL = url else {
                              // Uh-oh, an error occurred!
                              return
                            }
                            
                            guard var user = Database.shared.currentUser else { return }
                            user.profileImageUrl = downloadURL.absoluteString
                            Database.shared.save(user) { (user, error) in
                                guard let user = user else { return }
                                Database.shared.currentUser = user
                            }
                            
                          }
                        }
                        
                    }
            }
            }
        
            
        } else {
            dismiss(animated: true, completion: nil)
        }
        
    
                
    
}
                
}
