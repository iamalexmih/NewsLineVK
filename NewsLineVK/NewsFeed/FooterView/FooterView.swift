//
//  FooterView.swift
//  NewsLineVK
//
//  Created by Алексей Попроцкий on 15.08.2022.
//

import UIKit




class FooterView: UIView {
    
    private var footerLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = #colorLiteral(red: 0.6919150949, green: 0.7063220143, blue: 0.7199969292, alpha: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var footerLoadIndicate: UIActivityIndicatorView = {
       let indicate = UIActivityIndicatorView()
        indicate.translatesAutoresizingMaskIntoConstraints = false
        indicate.hidesWhenStopped = true
        return indicate
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(footerLabel)
        addSubview(footerLoadIndicate)
        
        footerLabel.anchor(top: topAnchor,
                           leading: leadingAnchor,
                           bottom: nil,
                           trailing: trailingAnchor,
                           padding: UIEdgeInsets(top: 8, left: 20, bottom: 777, right: 20))
        
        footerLoadIndicate.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        footerLoadIndicate.topAnchor.constraint(equalTo: footerLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    func showLoaderIndicate() {
        footerLoadIndicate.startAnimating()
    }
    
    func setTitle(_ title: String?) {
        footerLoadIndicate.stopAnimating()
        footerLabel.text = title
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
