//
//  NSHistoryDetailViewViewModel.swift
//  NoteSum
//
//  Created by Yuxuan Wu on 4/5/23.
//

import Foundation
import Firebase
import FirebaseFirestore

final class NSHistoryDetailViewViewModel {
    
    private let doc: NSDoc
    private let docImageURL: URL?
    private let docDecription: String
    
    init(doc: NSDoc) {
        self.doc = doc
        self.docImageURL = URL(string: doc.url)
        self.docDecription = doc.summary
    }
    
    public var title: String {
        doc.title
    }
    
    public func getDescription() -> String {
        return docDecription
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        // TOOD: Abstract to Image Manager
        guard let url = docImageURL else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        NSImageLoader.shared.download(url, completion: completion)
    }
    func getDocumentReference() -> DocumentReference {
        let db = Firestore.firestore()
        return db.collection("notes").document(self.doc.id);
    }
}
