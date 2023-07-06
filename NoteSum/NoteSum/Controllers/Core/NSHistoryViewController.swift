//
//  NSHistoryViewController.swift
//  NoteSum
//
//  Created by Yuxuan Wu on 3/19/23.
//

import UIKit

class NSHistoryViewController: UIViewController, NSHistoryListViewDelegate{
    
    private let historyListView = NSHistoryListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "History"
        setUpView()
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            historyListView.refreshDocs()
    }
    
    private func setUpView() {
        historyListView.delegate = self
//        historyListView.delegate = self
        view.addSubview(historyListView)
        NSLayoutConstraint.activate([
            historyListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            historyListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            historyListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            historyListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
    }
    
    // MARK: -NSHistoryListViewDelegate
    
    func nsDocListView(_ historyListView: NSHistoryListView, didSelectDoc doc: NSDoc) {

        let viewModel = NSHistoryDetailViewViewModel(doc: doc)
        let detailVC = NSHistoryDetailViewController(viewModel: viewModel)
        detailVC.navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
