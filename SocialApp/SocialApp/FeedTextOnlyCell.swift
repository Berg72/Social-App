//
//  FeedTextOnlyCell.swift
//  SocialApp
//
//  Created by Mark bergeson on 1/15/21.
//

import UIKit
import SDWebImage

class FeedTextOnlyCell: UITableViewCell {
    
    typealias GenericAction = () -> ()
    private var moreAction: GenericAction?
    private var shareAction: GenericAction?
    
    private let containerView = UIView()
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let timeLabel = UILabel()
    private let moreButton = UIButton(type: .roundedRect)
    private let primaryTextLabel = UILabel()
    private let shareButton = UIButton(type: .roundedRect)
    
    private var post: Post?
    private var countLabel = UILabel()
    private let countBackground = UIView()
    private var collectionViewHeightAnchor: NSLayoutConstraint?
    
    private lazy var  collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(post: Post, details: Bool = false, moreButtonAction:@escaping GenericAction, shareButtonAction: @escaping GenericAction) {
        self.moreAction = moreButtonAction
        self.shareAction = shareButtonAction
        self.post = post
        if let urlString = post.authorImgUrl {
            profileImageView.sd_setImage(with: URL(string: urlString), placeholderImage: nil)
        } else {
            profileImageView.image = UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysTemplate)
            profileImageView.tintColor = .lightGray
        }
        
        nameLabel.text = post.authorName
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        
        let relativeDate = formatter.localizedString(for: Date(timeIntervalSince1970: post.created), relativeTo: Date())
        timeLabel.text = relativeDate
        
        if details {
            primaryTextLabel.numberOfLines = 0
            primaryTextLabel.lineBreakMode = .byWordWrapping
        }
        
        primaryTextLabel.text = post.text
        
        if let urls = post.imageUrls, !urls.isEmpty {
            collectionViewHeightAnchor?.constant = UIScreen.main.bounds.width
            countBackground.isHidden = false
            countLabel.isHidden = false
            countLabel.text = "1/\(urls.count)"
        } else {
            collectionViewHeightAnchor?.constant = 0.0
            countBackground.isHidden = true
            countLabel.isHidden = true
        }
    }
    
}

private extension FeedTextOnlyCell {
    
    func setupView() {
        backgroundColor = .color(.backgroundcolor)
        contentView.backgroundColor = .color(.backgroundcolor)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        containerView.layer.applySketchShadow(color: .color(.shadowColor), alpha: 1.0, x: 0.0, y: 2.0, blur: 6.0, spread: 0.0)
        contentView.addSubview(containerView)
        
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.0).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0.0).isActive = true
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7.0).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7.0).isActive = true
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 23.0
        profileImageView.layer.masksToBounds = true
        containerView.addSubview(profileImageView)
        
        profileImageView.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 14.0).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 14.0).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 46.0).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 46.0).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        nameLabel.textColor = .color(.primaryTextColor)
        containerView.addSubview(nameLabel)
        
        nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 16.0).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor,constant: 14.0).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -60.0).isActive = true
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        timeLabel.textColor = UIColor.color(.primaryTextColor).withAlphaComponent(0.40)
        containerView.addSubview(timeLabel)
        
        timeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant: 4.0).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor,constant: 14.0).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -60.0).isActive = true
        
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.setImage(UIImage(named: "more-button")?.withRenderingMode(.alwaysOriginal), for: .normal)
        moreButton.addTarget(self, action: #selector(moreButtonAction), for: .touchUpInside)
        containerView.addSubview(moreButton)
        
        moreButton.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 4.0).isActive = true
        moreButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -4.0).isActive = true
        moreButton.widthAnchor.constraint(equalToConstant: 48.0).isActive = true
        moreButton.heightAnchor.constraint(equalToConstant: 48.0).isActive = true
        
        primaryTextLabel.translatesAutoresizingMaskIntoConstraints = false
        primaryTextLabel.font = UIFont.systemFont(ofSize: 19.0, weight: .regular)
        primaryTextLabel.textColor = UIColor.color(.primaryTextColor)
        primaryTextLabel.numberOfLines = 2
        primaryTextLabel.lineBreakMode = .byTruncatingTail
        containerView.addSubview(primaryTextLabel)
        
        primaryTextLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor,constant: 14.0).isActive = true
        primaryTextLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 14.0).isActive = true
        primaryTextLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -14.0).isActive = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SingleImageCell.self, forCellWithReuseIdentifier: SingleImageCell.reuseIdentifier())
        contentView.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: primaryTextLabel.bottomAnchor, constant: 14.0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        collectionViewHeightAnchor = collectionView.heightAnchor.constraint(equalToConstant: 0.0)
        collectionViewHeightAnchor?.isActive = true
        
        
        countBackground.translatesAutoresizingMaskIntoConstraints = false
        countBackground.backgroundColor = .color(.primaryTextColor)
        countBackground.layer.cornerRadius = 13.0
        contentView.addSubview(countBackground)
        
        countBackground.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: 14.0).isActive = true
        countBackground.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: -14.0).isActive = true
        countBackground.heightAnchor.constraint(equalToConstant: 26.0).isActive = true
        countBackground.widthAnchor.constraint(equalToConstant: 34.0).isActive = true
        
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .medium)
        countLabel.textColor = .white
        countBackground.addSubview(countLabel)
        
        countLabel.centerYAnchor.constraint(equalTo: countBackground.centerYAnchor).isActive = true
        countLabel.centerXAnchor.constraint(equalTo: countBackground.centerXAnchor).isActive = true
        
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.setImage(UIImage(named: "Share Icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        shareButton.addTarget(self, action: #selector(shareButtonAction), for: .touchUpInside)
        containerView.addSubview(shareButton)
        
        shareButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 12.0).isActive = true
        shareButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5.0).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
        shareButton.widthAnchor.constraint(equalToConstant: 36.0).isActive = true
        shareButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -14.0).isActive = true
        
    }
    
}

private extension FeedTextOnlyCell {
    
    @objc
    func moreButtonAction() {
        moreAction?()
    }


    @objc
    func shareButtonAction() {
        shareAction?()
    }
}

extension FeedTextOnlyCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let post = post, let urls = post.imageUrls, !urls.isEmpty else {
            return 0
        }
        return urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SingleImageCell.reuseIdentifier(), for: indexPath)
        
        if let cell = cell as? SingleImageCell, let post = post, let urls = post.imageUrls, let url = urls[safe: indexPath.row] {
            cell.configure(urlString: url)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
        let w = UIScreen.main.bounds.width
        guard let post = post, let urls = post.imageUrls, !urls.isEmpty else {
            return
        }
        if scrollView.contentOffset.x == 0.0 {
            countLabel.text = "1/\(urls.count)"
        } else {
            var page = Int(scrollView.contentOffset.x / w)
            page += 1
            countLabel.text = "\(page)/\(urls.count)"
        }
    }
    
}
