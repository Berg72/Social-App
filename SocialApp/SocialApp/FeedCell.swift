//
//  FeedCell.swift
//  SocialApp
//
//  Created by Mark bergeson on 1/15/21.
//

import UIKit

class FeedCell: UITableViewCell {
    
    private let nameLabel = UILabel()
    private let timeLabel = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(name: String, time: String) {
        nameLabel.text = name
        timeLabel.text = time
    }
    
}

    private extension FeedCell {
    
    func setupView() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        contentView.addSubview(nameLabel)
        
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15.0).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 15.0).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 18.0).isActive = true
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.font = UIFont.systemFont(ofSize: 10.0, weight: .light)
        contentView.addSubview(timeLabel)
        
        timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2.0).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 15.0).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 14.0).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15.0).isActive = true
    }
    
}
