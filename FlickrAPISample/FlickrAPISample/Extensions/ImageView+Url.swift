//
//  ImageView+Url.swift
//  FlickrAPISample
//
//  Created by Erica Geraldes on 22/07/2019.
//  Copyright © 2019 Erica Geraldes. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        activityIndicator.hidesWhenStopped = true
        self.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        guard let url = URL(string: urlString) else { return }
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            activityIndicator.stopAnimating()
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                activityIndicator.stopAnimating()
                return
            }
            
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                    activityIndicator.stopAnimating()
                }
            }
            
        }).resume()
    }}
