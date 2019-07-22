//
//  TagsView.swift
//  FlickrAPISample
//
//  Created by Erica Geraldes on 22/07/2019.
//  Copyright © 2019 Erica Geraldes. All rights reserved.
//

import UIKit

class TagsView: UIView {
    
    // MARK: - Properties
    
    var offset: CGFloat = 5
    var maxHeight: Double = 37.0
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = Colors.primary
    }
    
    // MARK: - Public functions
    
    func create(cloud tags: [UIButton]) {
        var x = offset
        var y = offset
        for (index, tag) in tags.enumerated() {
            tag.frame = CGRect(x: x, y: y, width: tag.frame.width, height: tag.frame.height)
            x += tag.frame.width + offset
            
            let nextTag = index <= tags.count - 2 ? tags[index + 1] : tags[index]
            let nextTagWidth = nextTag.frame.width + offset
            
            if x + nextTagWidth > frame.width {
                x = offset
                y += tag.frame.height + offset
            }
            
            addSubview(tag)
        }
    }
    
    static func button(with title: String) -> UIButton {
        let font = UIFont.preferredFont(forTextStyle: .headline)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let size = title.size(withAttributes: attributes)
        
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = font
        button.setTitleColor(Colors.secondary, for: .normal)
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = size.height / 2
        button.layer.borderColor = Colors.secondary.cgColor
        button.frame = CGRect(x: 0.0, y: 0.0, width: size.width + 10.0, height: size.height + 10.0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0)
        return button
    }
}
