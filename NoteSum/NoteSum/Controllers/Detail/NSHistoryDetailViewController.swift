//
//  NSHistoryDetailViewController.swift
//  NoteSum
//
//  Created by Yuxuan Wu on 4/5/23.


import UIKit
import Firebase
import FirebaseFirestore

/// For single doc
final class NSHistoryDetailViewController: UIViewController, UITextViewDelegate{

    private let viewModel: NSHistoryDetailViewViewModel
    
    let detailView: NSHistoryDetailView

    init(viewModel: NSHistoryDetailViewViewModel) {
        self.viewModel = viewModel
        self.detailView = NSHistoryDetailView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.title
        navigationItem.largeTitleDisplayMode = .never
        view.addSubview(detailView)
        // Do any additional setup after loading the view.
        setUpView()
    }
    
    func setUpView() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        detailView.DetailDocTextView.delegate = self
    }
    
    func textViewDidChange(_ textView: UITextView) {
        // Save textView.text to Firebase
        let documentRef = viewModel.getDocumentReference()
        documentRef.updateData(["summary": textView.text ?? "error updating summary"]) { error in
            if let error = error {
                print("Error updating description: \(error)")
            } else {
                print("Description successfully updated")
            }
        }
        
    }



}
