//
//  HistoryListViewViewModel.swift
//  NoteSum
//
//  Created by Yuxuan Wu on 3/26/23.
//

import Foundation
import UIKit
import FirebaseFirestore
import Firebase

protocol NSHistoryListViewViewModelDelegate: AnyObject {
    func didloadInitialDocs()
    func didSelectDoc(_ doc: NSDoc)
}

final class NSHistoryListViewViewModel: NSObject {
    
    public weak var delegate: NSHistoryListViewViewModelDelegate?
    
    private var docs: [NSDoc] = []
    {
        didSet {
            for doc in docs {
                let viewModel = NSHistoryCollectionViewCellViewModel(
                    docName: doc.title,
                    docDate: doc.date,
                    docImageURL: URL(string: doc.url)
                )
                cellViewModels.append(viewModel)
            }
        }
    }
    
    private var cellViewModels: [NSHistoryCollectionViewCellViewModel] = []
    /// fetch docs from firebase?
    /// - Parameter url: Optional for firebase if needed
    public func fetchDocs() {
        self.docs.removeAll()
        cellViewModels.removeAll()
        fetchUserNotes { [weak self] success in
                if success {
                    print("fetched success!!!")
                    if let docCount = self?.docs.count, docCount > 0 {
//                                        self?.delegate?.didloadInitialDocs()
                        DispatchQueue.main.async {
                            self?.delegate?.didloadInitialDocs()
                        }
                                    }
                    
                }
            }
        
        // after success load the docs: call this:
//        DispatchQueue.main.async {
//            // keep weak for "self?.delegate?.didloadInitialDocs()"
//            self.delegate?.didloadInitialDocs()
//        }
//
//        // suppose to get data from server, but use the fake data for demo
////        addFakeData()
//        fetchUserNotes()
    }
    public func fetchUserNotes(completion: @escaping (_ success: Bool) -> Void) {
        // Get the current user's UID
        let user = Auth.auth().currentUser
//        guard let currentUserUID = Auth.auth().currentUser?.uid else {
//            print("User not logged in")
//                    completion(false)
//                    return
//        }
        if let user = user {
            
            let currentUserUID = user.uid
            print("user id: ", currentUserUID)
            
            
            // Get a reference to the Firebase Realtime Database
            let db = Firestore.firestore()
            
            
            // Query notes with the user's UID
            db.collection("notes").whereField("user_id", isEqualTo: currentUserUID).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching notes: \(error.localizedDescription)")
                    completion(false)
                } else {
                    guard let documents = querySnapshot?.documents else {
                        print("No notes found for the user")
                        completion(false)
                        return
                    }
                    //                print("documents: ", documents)
                    var loadedDocs: [NSDoc] = []
                    for document in documents {
                        let noteData = document.data()
                        
                        let noteId = noteData["id"] as? String ?? ""
                        let noteImageUrl = noteData["url"] as? String ?? ""
                        let noteSummary = noteData["summary"] as? String ?? ""
                        let noteTitle = noteData["title"] as? String ?? ""
                        let noteDate = noteData["date"] as? String ?? "04/23/2023"
                        
                        // Create a Note object or store the data as needed
                        //                    print("Note title: \(noteTitle), summary: \(noteSummary), image URL: \(noteImageUrl)")
                        let doc = NSDoc(id: noteId, title: noteTitle, date: noteDate, url: noteImageUrl, summary: noteSummary)
                        loadedDocs.append(doc)
                    }
                    self.docs = loadedDocs
                    print("loaded docs: ", loadedDocs.count)
                    //                self.updateCellViewModels()
                    completion(true)
                    print("loaded docs: ", self.docs)
                }
            }
        }
        
    }
    
    public func addFakeData() {
        //        let viewModel = NSHistoryCollectionViewCellViewModel(docName: "COMS 6111", docDate: "04/05/2023", docImageURL: URL(string: ""))
        //        cellViewModels.append(viewModel)
        var newDocs: [NSDoc] = []
        let doc1 = NSDoc(id: "1", title: "COMS 6111", date: "04/05/2023", url: "https://raw.githubusercontent.com/CalendulaED/SpongeBob/main/Ex1.jpeg", summary: "This is COMS 6111 Summary:")
        let doc2 = NSDoc(id: "1", title: "COMS 4995", date: "04/02/2023", url: "https://raw.githubusercontent.com/CalendulaED/SpongeBob/main/Ex2.jpeg", summary: "This is COMS 4995 Summary:")
        let doc3 = NSDoc(id: "1", title: "COMS 4735", date: "04/01/2023", url: "https://raw.githubusercontent.com/CalendulaED/SpongeBob/main/Ex3.jpeg", summary: "This is COMS 4735 Summary:")
        let doc4 = NSDoc(id: "1", title: "COMS 4732", date: "04/04/2023", url: "https://raw.githubusercontent.com/CalendulaED/SpongeBob/main/Ex4.jpeg", summary: "This is COMS 4732 Summary:")
        let doc5 = NSDoc(id: "1", title: "COMS 4111", date: "04/04/2023", url: "https://raw.githubusercontent.com/CalendulaED/SpongeBob/main/Ex5.jpeg", summary: "This is COMS 4111 Summary:")
        newDocs.append(doc1)
        newDocs.append(doc2)
        newDocs.append(doc3)
        newDocs.append(doc4)
        newDocs.append(doc5)
        docs = newDocs
    }
}

// MARK: - CollectionView

extension NSHistoryListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt IndexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSHistoryCollectionViewCell.cellIdentifier, for: IndexPath) as? NSHistoryCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        let viewModel = cellViewModels[IndexPath.row]
        cell.configure(with: viewModel)
        //        cell.backgroundColor = .systemBlue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-30)/2
        
        return CGSize(width: width, height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let doc = docs[indexPath.row]
        delegate?.didSelectDoc(doc)
    }
}

