//
//  Teste.swift
//  FlickrAPISample
//
//  Created by Erica Geraldes on 21/07/2019.
//  Copyright © 2019 Erica Geraldes. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String = "Cell"
    static var height: Double = 150.0
    static var width: Double = 150.0
    static var leftPadding: CGFloat = 25.0
    static var rightPadding: CGFloat = 25.0
    static var topPadding: CGFloat = 0
    static var bottomPadding: CGFloat = 0
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            self.contentView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            self.contentView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
}
