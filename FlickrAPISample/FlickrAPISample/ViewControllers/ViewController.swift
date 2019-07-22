//
//  ViewController.swift
//  FlickrAPISample
//
//  Created by Erica Geraldes on 18/07/2019.
//  Copyright © 2019 Erica Geraldes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private(set) var searchBar: SearchBar?
    let viewModel: MainViewModelDelegate
    weak var collectionView: UICollectionView?
    private(set) var tags: [String] = []
    private(set) var tagView: TagsView?
   
    public init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        self.view.backgroundColor = Colors.primary
    }
}

private extension ViewController {
    func configureSearchBar() {
        searchBar = SearchBar(delegate: self)
        guard let searchBar = self.searchBar else { return }
        searchBar.becomeFirstResponder()
        self.view.addSubview(searchBar)
       searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                                       constant: Spacing.large).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    func configureCollectionView() {
        guard let tagView = self.tagView else { return }
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: tagView.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = Colors.primary
        
        self.collectionView = collectionView
        
    }
    
    func configureTagsView() {
        guard let searchBar = self.searchBar else { return }
        let tags = self.tags.map({ TagsView.button(with: $0) })
        if let tagView = self.tagView { tagView.removeFromSuperview() }
        let frame = CGRect.zero
        let tagsView = TagsView(frame: frame)
        tagsView.backgroundColor = Colors.primary
        tagsView.create(cloud: tags)
        self.view.addSubview(tagsView)
        tagsView.translatesAutoresizingMaskIntoConstraints = false
        tagsView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tagsView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tagsView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tagsView.heightAnchor.constraint(equalToConstant: CGFloat(tagsView.maxHeight*Double(tags.count))).isActive = true
        self.tagView = tagsView
    }
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.getTotalImagesCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell() }
        
        guard let urlString = self.viewModel.getImageUrl(for: indexPath.row) else { return cell }
        cell.imageView.imageFromServerURL(urlString: urlString)
    
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CustomCollectionViewCell.width, height: CustomCollectionViewCell.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: CustomCollectionViewCell.topPadding,
                            left: CustomCollectionViewCell.leftPadding,
                            bottom: CustomCollectionViewCell.bottomPadding,
                            right: CustomCollectionViewCell.rightPadding)
    }
    
}

extension ViewController: UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        self.tags.append(text)
        configureTagsView()
        
        searchBar.text = ""
        self.viewModel.cancelRequest()
        self.viewModel.getImages(for: self.tags) {
            DispatchQueue.main.async { [weak self] in
                self?.configureCollectionView()
            }
            
        }
    }
}
