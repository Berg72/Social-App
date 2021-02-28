//
//  ComposeTextEntryCell.swift
//  SocialApp
//
//  Created by Mark bergeson on 2/23/21.
//

import UIKit

class ComposeTextEntryCell: UITableViewCell {
    
    let textView = UITextView()
    private var placeholderText = ""
    
    typealias TextChanged = (String?) -> ()
    private var tableView: UITableView?
    private var textChanged: TextChanged?
    
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
    
    func configure(text: String?, tableView: UITableView, textChanged: @escaping TextChanged) {
        self.placeholderText = "Write your post..."
        self.tableView = tableView
        self.textChanged = textChanged
        
        if let text = text {
            textView.textColor = UIColor.color(.primaryTextColor)
            textView.text = text
        } else {
            textView.textColor = UIColor.color(.primaryTextColor).withAlphaComponent(0.15)
            textView.text = placeholderText
        }
    }
}

private extension ComposeTextEntryCell {
    
    func setupView() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        textView.textColor = UIColor.color(.primaryTextColor)
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.textContainer.lineFragmentPadding = 0
        textView.delegate = self
        textView.isScrollEnabled = false
        contentView.addSubview(textView)
        
        textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14.0).isActive = true
        textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14.0).isActive = true
        textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14.0).isActive = true
        textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14.0).isActive = true
        textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 22.0).isActive = true
    }
}

extension ComposeTextEntryCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        self.tableView?.beginUpdates()
        self.tableView?.endUpdates()
        textChanged?(textView.text)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        textView.textColor = UIColor.color(.primaryTextColor)
        
        if textView.text == self.placeholderText {
            textView.text = ""
        } else if textView.text.count == 1, text == "" {
            textView.text = self.placeholderText
            textView.textColor = UIColor.color(.primaryTextColor).withAlphaComponent(0.15)
            textView.selectedRange = NSMakeRange(0, 0)
            textChanged?(nil)
            return false
        } else if textView.text.count == 0, text == "" {
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == self.placeholderText {
            textView.text = ""
            textView.textColor = UIColor.color(.primaryTextColor)
        } else {
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = placeholderText
            textView.textColor = UIColor.color(.primaryTextColor).withAlphaComponent(0.15)
        } else {
            
        }
    }
}
