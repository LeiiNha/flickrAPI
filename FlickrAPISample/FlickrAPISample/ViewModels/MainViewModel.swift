//
//  MainViewModel.swift
//  FlickrAPISample
//
//  Created by Erica Geraldes on 21/07/2019.
//  Copyright © 2019 Erica Geraldes. All rights reserved.
//

import UIKit

protocol MainViewModelDelegate: class {
    func getTotalImagesCount() -> Int
    func getImages(for tags: [String], completion: @escaping () -> Void)
    func getImage(for index: Int, completion: @escaping (UIImage?) -> Void)
}

final class MainViewModel {
    
    let networkManager: NetworkManager
    var imageResults: ImageResults?
    var isDownloading: Bool = false
    var limitBeforeDownload: Int = 20
    var totalInPage: Int = 0
    
    private enum Constants {
        static let defaultPage: Int = 1
    }
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    private func downloadImages(tags: [String], page: Int, completion: @escaping () -> Void) {
        self.isDownloading = true
        networkManager.getImagesWithTags(page: page, tags: tags) { [unowned self] data, error in
            guard let data = data else { return }
            var count: Int = 0
            
            if self.imageResults == nil {
                
                self.imageResults = data
                
            } else {
                
                var photos = self.imageResults!.photo
                self.imageResults = data
                photos.append(contentsOf: data.photo)
                count = self.imageResults!.photo.count
                self.imageResults!.photo = photos
            }
            
            self.totalInPage += self.imageResults!.photo.count
            for index in count...self.imageResults!.photo.count-1 {
                self.networkManager.getImageSize(photoId: self.imageResults!.photo[index].identifier) { [unowned self] sizes, error in
                    guard error != nil else { return }
                    self.imageResults!.photo[index].sizes = sizes
                    if index == self.imageResults!.photo.count - 1 { self.isDownloading = false }
                    completion()
                }
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                completion(UIImage(data: data))
            }
        }
    }
}

extension MainViewModel: MainViewModelDelegate {
    func getTotalImagesCount() -> Int {
        return self.totalInPage
    }
    
    func getImages(for tags: [String], completion: @escaping () -> Void) {
        self.downloadImages(tags: tags, page: Constants.defaultPage, completion: completion)
    }
    
    func getImage(for index: Int, completion: @escaping (UIImage?) -> Void) {
        guard let imageResults = self.imageResults, let sizes = imageResults.photo[index].sizes else { return }
        self.downloadImage(from: URL(string: sizes.size[1].source)!) { image in
            completion(image)
        }
    }
}
