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
    private let numberOfCommentsLabel = UILabel()
    private let separator = UIView()
    private let commentImageView = UIImageView()
    private let commentLabel = UILabel()
    private let shareImageView = UIImageView()
    private let shareLabel = UILabel()
    private let shareButton = UIButton(type: .roundedRect)
    
    
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
        
        if post.commentCount == 0 {
            numberOfCommentsLabel.text = "Be the first to comment"
        } else if post.commentCount == 1 {
            numberOfCommentsLabel.text = "1 comment"
        } else {
            numberOfCommentsLabel.text = "\(post.commentCount) comments"
        }
        
        
    }
    
}

private extension FeedTextOnlyCell {
    
    func setupView() {
        backgroundColor = .color(.backgroundcolor)
        contentView.backgroundColor = .color(.backgroundcolor)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 6.0
        containerView.layer.applySketchShadow(color: .color(.shadowColor), alpha: 1.0, x: 0.0, y: 2.0, blur: 6.0, spread: 0.0)
        contentView.addSubview(containerView)
        
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12.0).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12.0).isActive = true
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
        
        
//        containerView.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        
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
        
        numberOfCommentsLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfCommentsLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        numberOfCommentsLabel.textColor = UIColor.color(.secondaryTextColor)
        containerView.addSubview(numberOfCommentsLabel)
        
        numberOfCommentsLabel.topAnchor.constraint(equalTo: primaryTextLabel.bottomAnchor, constant: 12.0).isActive = true
        numberOfCommentsLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 14.0).isActive = true
        
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor.color(.primaryTextColor).withAlphaComponent(0.10)
        containerView.addSubview(separator)
        
        separator.topAnchor.constraint(equalTo: numberOfCommentsLabel.bottomAnchor, constant: 10.0).isActive = true
        separator.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        separator.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        
        commentImageView.translatesAutoresizingMaskIntoConstraints = false
        commentImageView.contentMode = .scaleAspectFit
        commentImageView.image = UIImage(named: "Comment Icon")
        containerView.addSubview(commentImageView)
        
        commentImageView.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 14.0).isActive = true
        commentImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 14.0).isActive = true
        commentImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -14.0).isActive = true
        commentImageView.widthAnchor.constraint(equalToConstant: 23.0).isActive = true
        commentImageView.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        commentLabel.textColor = UIColor.color(.primaryTextColor).withAlphaComponent(0.60)
        commentLabel.text = "Comment"
        containerView.addSubview(commentLabel)
        
        commentLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 14.0).isActive = true
        commentLabel.leadingAnchor.constraint(equalTo: commentImageView.trailingAnchor, constant: 6.0).isActive = true
        commentLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        shareImageView.translatesAutoresizingMaskIntoConstraints = false
        shareImageView.contentMode = .scaleAspectFit
        shareImageView.image = UIImage(named: "Share Icon")
        containerView.addSubview(shareImageView)
        
        shareImageView.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 14.0).isActive = true
        
        shareImageView.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
        shareImageView.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        shareLabel.translatesAutoresizingMaskIntoConstraints = false
        shareLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        shareLabel.textColor = UIColor.color(.primaryTextColor).withAlphaComponent(0.60)
        shareLabel.text = "Share"
        containerView.addSubview(shareLabel)
        
        shareLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 14.0).isActive = true
        shareLabel.leadingAnchor.constraint(equalTo: shareImageView.trailingAnchor, constant: 6.0).isActive = true
        shareLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.addTarget(self, action: #selector(shareButtonAction), for: .touchUpInside)
        containerView.addSubview(shareButton)
        
        shareButton.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 0.0).isActive = true
        
        shareButton.trailingAnchor.constraint(equalTo: shareLabel.trailingAnchor).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 48.0).isActive = true
        
        if !FeatureFlag.comments.enabled() {
            commentLabel.isHidden = true
            commentImageView.isHidden = true
            numberOfCommentsLabel.isHidden = true
            shareImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 14.0).isActive = true
            shareButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 14.0).isActive = true
            numberOfCommentsLabel.heightAnchor.constraint(equalToConstant: 0.0).isActive = true
        } else {
            shareImageView.leadingAnchor.constraint(equalTo: commentLabel.trailingAnchor, constant: 28.0).isActive = true
            shareButton.leadingAnchor.constraint(equalTo: commentLabel.trailingAnchor, constant: 28.0).isActive = true
            numberOfCommentsLabel.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
        }
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
