//
//  AlertCell.swift
//  SocialApp
//
//  Created by Mark bergeson on 2/16/21.
//

import UIKit

class AlertCell: UITableViewCell {
    
    private let containerView = UIView()
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let timeLabel = UILabel()
    private let primaryTextLabel = UILabel()
    
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
    
    func configure(alert: Alert) {
        
        if let urlString = alert.authorImgUrl {
            profileImageView.sd_setImage(with: URL(string: urlString), placeholderImage: nil)
        } else {
            profileImageView.image = UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysTemplate)
            profileImageView.tintColor = .lightGray
        }
        
        let authorName = alert.authorName?.components(separatedBy: " ").first ?? ""
        let subject = alert.subject ?? ""
        
        let attrAuthorName = NSMutableAttributedString(string: authorName, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.color(.primaryTextColor)])
        
        let attrSubject = NSAttributedString(string: " \(subject.lowercased())", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0, weight: .semibold), NSAttributedString.Key.foregroundColor: UIColor.color(.primaryTextColor)])
        
        attrAuthorName.append(attrSubject)
        
        nameLabel.attributedText = attrAuthorName
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        
        let relativeDate = formatter.localizedString(for: Date(timeIntervalSince1970: alert.created), relativeTo: Date())
        timeLabel.text = relativeDate
        primaryTextLabel.text = alert.text
        
        if let id = alert.id, UserDefaults.standard.bool(forKey: id) {
            containerView.backgroundColor = .color(.selectedColor)
        } else {
            containerView.backgroundColor = .white
        }
    
    }
    
}

private extension AlertCell {
    
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
            
            primaryTextLabel.translatesAutoresizingMaskIntoConstraints = false
            primaryTextLabel.font = UIFont.systemFont(ofSize: 19.0, weight: .regular)
            primaryTextLabel.textColor = UIColor.color(.primaryTextColor)
            primaryTextLabel.numberOfLines = 1
            primaryTextLabel.lineBreakMode = .byTruncatingTail
            containerView.addSubview(primaryTextLabel)
            
            primaryTextLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor,constant: 14.0).isActive = true
            primaryTextLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 14.0).isActive = true
            primaryTextLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -14.0).isActive = true
            primaryTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14.0).isActive = true
        }
            
    }

