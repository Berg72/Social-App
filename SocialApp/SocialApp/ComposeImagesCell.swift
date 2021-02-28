//
//  ComposeImagesCell.swift
//  SocialApp
//
//  Created by Mark bergeson on 2/25/21.
//

import UIKit

class ComposeImagesCell: UITableViewCell {
    
    typealias ButtonAction = (_ position: Int) -> ()
    private var buttonAction: ButtonAction?
    
    private var countLabel = UILabel()
    private let countBackground = UIView()
    private var currentPage = 0
    private let xButton = UIButton(type: .roundedRect)
    
    private lazy var  collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    private var datasource = [UIImage]()
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(images: [UIImage], removeImageTapped: @escaping ButtonAction) {
        self.datasource = images
        self.buttonAction = removeImageTapped
        
        if images.count > 1 {
            countBackground.isHidden = false
            countLabel.isHidden = false
            countLabel.text = "1/\(images.count)"
        } else {
            countBackground.isHidden = true
            countLabel.isHidden = true
        }
        collectionView.reloadData()
        
    }
    
}

private extension ComposeImagesCell {
    
    func setupview() {
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SingleImageCell.self, forCellWithReuseIdentifier: SingleImageCell.reuseIdentifier())
        contentView.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        
        countBackground.translatesAutoresizingMaskIntoConstraints = false
        countBackground.backgroundColor = .color(.primaryTextColor)
        countBackground.layer.cornerRadius = 13.0
        contentView.addSubview(countBackground)
        
        countBackground.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14.0).isActive = true
        
        countBackground.heightAnchor.constraint(equalToConstant: 26.0).isActive = true
        countBackground.widthAnchor.constraint(equalToConstant: 34.0).isActive = true
        
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .medium)
        countLabel.textColor = .white
        countBackground.addSubview(countLabel)
        
        countLabel.centerYAnchor.constraint(equalTo: countBackground.centerYAnchor).isActive = true
        countLabel.centerXAnchor.constraint(equalTo: countBackground.centerXAnchor).isActive = true
        
        xButton.translatesAutoresizingMaskIntoConstraints = false
        xButton.backgroundColor = .color(.primaryTextColor)
        xButton.layer.cornerRadius = 13.0
        xButton.setImage(UIImage(named: "xmark")?.withRenderingMode(.alwaysOriginal), for: .normal)
        xButton.addTarget(self, action: #selector(xButtonAction), for: .touchUpInside)
        contentView.addSubview(xButton)
        
        xButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14.0).isActive = true
        xButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14.0).isActive = true
        xButton.heightAnchor.constraint(equalToConstant: 26.0).isActive = true
        xButton.widthAnchor.constraint(equalToConstant: 26.0).isActive = true
        
        countBackground.trailingAnchor.constraint(equalTo: xButton.leadingAnchor, constant: -6.0).isActive = true
    }
    
    @objc
    func xButtonAction() {
        self.buttonAction?(currentPage)
    }
    
}

extension ComposeImagesCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SingleImageCell.reuseIdentifier(), for: indexPath)
        
        if let cell = cell as? SingleImageCell {
            cell.configure(image: datasource[indexPath.row])
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
        if scrollView.contentOffset.x == 0.0 {
            countLabel.text = "1/\(datasource.count)"
            currentPage = 0
        } else {
            var page = Int(scrollView.contentOffset.x / w)
            currentPage = page
            page += 1
            countLabel.text = "\(page)/\(datasource.count)"
        }
    
    }
    
}
