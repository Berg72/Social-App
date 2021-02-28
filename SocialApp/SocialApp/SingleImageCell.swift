//
//  SingleImageCell.swift
//  SocialApp
//
//  Created by Mark bergeson on 2/25/21.
//

import UIKit
import SDWebImage

class SingleImageCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(image: UIImage) {
        imageView.image = image
    }
    
    func configure(urlString: String) {
        imageView.sd_setImage(with: URL(string: urlString), placeholderImage: nil)
    }
    
}

private extension SingleImageCell {
    
    func setupView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
}
