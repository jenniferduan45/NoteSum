//
//  NSHistoryListView.swift
//  NoteSum
//
//  Created by Yuxuan Wu on 3/23/23.
//

import UIKit

protocol NSHistoryListViewDelegate: AnyObject {
    func nsDocListView(
        _ historyListView: NSHistoryListView,
        didSelectDoc doc: NSDoc
    )
}

/// General View for showing the Notes scanning history
class NSHistoryListView: UIView {
//    func didSelectNote(_ note: Note) {
//        // Handle the note selection
//        let detailViewController = NSHistoryDetailViewController()
//        detailViewController.note = note
//        // Find the view controller that owns this view
//        if let viewController = findViewController() {
//            viewController.navigationController?.pushViewController(detailViewController, animated: true)
//        }
//    }
//
//    private func findViewController() -> UIViewController? {
//            var responder: UIResponder? = self
//            while responder != nil {
//                responder = responder?.next
//                if let viewController = responder as? UIViewController {
//                    return viewController
//                }
//            }
//            return nil
//        }
    
    public weak var delegate: NSHistoryListViewDelegate?
    
    //TODO: - ViewModel for History View
    private let viewModel = NSHistoryListViewViewModel()
    
    /// Loading Spinner
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(NSHistoryCollectionViewCell.self, forCellWithReuseIdentifier: NSHistoryCollectionViewCell.cellIdentifier)
        return collectionView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        //        backgroundColor = .systemBlue
        addSubviews(collectionView, spinner)
        addConstraints()
        spinner.startAnimating()
        // add delegate when need to fetch data from firebase
        viewModel.delegate = self
        viewModel.fetchDocs()
        setUpCollectionView()
        
    }
    func refreshDocs() {
        print("refreshed!!")
        // FIXME: data is empty after refresh
        spinner.startAnimating()
        viewModel.fetchDocs()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
        ])
    }
    
    private func setUpCollectionView() {
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
    }
}


extension NSHistoryListView: NSHistoryListViewViewModelDelegate {
    func didSelectDoc(_ doc: NSDoc) {
        delegate?.nsDocListView(self, didSelectDoc: doc)
    }
    
    func didloadInitialDocs() {
        
        self.spinner.stopAnimating()
        self.collectionView.isHidden = false
        
        collectionView.reloadData()
                
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1
        }
    }
}
