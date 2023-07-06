//
//  NSHistoryCollectionViewCellViewModel.swift
//  NoteSum
//
//  Created by Yuxuan Wu on 3/26/23.
//

import Foundation

final class NSHistoryCollectionViewCellViewModel {
    public let docName: String
    public let docDate: String
    private let docImageURL: URL?
    
    
    
    
    // MARK: - Init
    
    init (
        docName: String,
        docDate: String,
        docImageURL: URL?
    ) {
        self.docName = docName
        self.docDate = docDate
        self.docImageURL = docImageURL
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        // TOOD: Abstract to Image Manager
        guard let url = docImageURL else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        NSImageLoader.shared.download(url, completion: completion)
    }
}
