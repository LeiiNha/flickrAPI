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
    func getImageUrl(for index: Int) -> String?
    func cancelRequest()
}

final class MainViewModel {
    
    let networkManager: NetworkManager
    private(set) var imageResults: ImageResults?
    private(set) var isDownloading: Bool = false
    private(set) var limitBeforeDownload: Int = 20
    private(set) var totalInPage: Int = 0
    
    private enum Constants {
        static let defaultPage: Int = 1
    }
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    private func downloadImages(tags: [String], page: Int, completion: @escaping () -> Void) {
        self.isDownloading = true
        networkManager.getImagesWithTags(page: page, tags: tags) { [weak self] data, error in
            guard let data = data else { return }
            guard let self = self else { return }
            
            if var imageResults = self.imageResults {
                var photos = imageResults.photo
                self.imageResults = data
                photos.append(contentsOf: data.photo)
                imageResults.photo = photos
                self.imageResults = imageResults
            } else {
                self.imageResults = data
            }
            guard var imageResults = self.imageResults else { return }
            
            self.totalInPage += imageResults.photo.count
            for (n, photo) in imageResults.photo.enumerated() {
                self.networkManager.getImageSize(photoId: photo.identifier,
                                                 completion: { [weak self] sizes, error in
                                                    guard error == nil else { return }
                                                    imageResults.photo[n].sizes = sizes
                                                    self?.imageResults = imageResults
                                                    completion()
                })
                
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
    
    func getImageUrl(for index: Int) -> String? {
        guard let imageResults = self.imageResults, index < imageResults.photo.count, let sizes = imageResults.photo[index].sizes else { return nil }
        return sizes.size[1].source
    }
    
    func cancelRequest() {
        self.networkManager.cancelRequest()
    }
}
