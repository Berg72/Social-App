//
//  WebController.swift
//  SocialApp
//
//  Created by Mark bergeson on 2/7/21.
//

import UIKit
import WebKit

class WebController: UIViewController {
    
    private let url: URL
    private var webView = WKWebView()
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: url))
        
        if url.absoluteString.contains("privacy") {
            navigationItem.title = "Privacy Policy"
        } else {
            navigationItem.title = " Terms & Conditions"
        }
        
        if let count = navigationController?.viewControllers.count, count == 1 {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonAction))
        }
    }
    
    @objc
    func closeButtonAction() {
        dismiss(animated: true, completion: nil)
    }
}


extension WebController: WKNavigationDelegate {
    
}
