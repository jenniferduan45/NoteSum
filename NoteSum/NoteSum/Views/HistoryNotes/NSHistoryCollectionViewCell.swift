//
//  NSHistoryCollectionViewCell.swift
//  NoteSum
//
//  Created by Yuxuan Wu on 3/26/23.
//

import UIKit

/// Single cell for each scan doc
class NSHistoryCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "NSHistoryCollectionViewCell"
    
    /// Doc Image (Image)
    private let DocimageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// Doc name (Text)
    private let DocNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Doc Date (Text)
    private let DocDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubviews(DocimageView, DocNameLabel, DocDateLabel)
        addConstraints()
        setUpLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func setUpLayer() {
        // TODO: - Add layer modifier
        contentView.layer.cornerRadius = 8
    }
    
    /// Constraint for Doc Date, Name, Image
    private func addConstraints() {
        NSLayoutConstraint.activate([
            DocDateLabel.heightAnchor.constraint(equalToConstant: 30),
            DocNameLabel.heightAnchor.constraint(equalToConstant: 30),
            
            DocDateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            DocDateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            DocNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            DocNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            
            DocDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            DocNameLabel.bottomAnchor.constraint(equalTo: DocDateLabel.topAnchor),
            
            DocimageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            DocimageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            DocimageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            DocimageView.bottomAnchor.constraint(equalTo: DocNameLabel.topAnchor, constant: -5),
        ])
        // TODO: - Placeholder, need to remove
        //        DocimageView.backgroundColor = .systemBlue
        //        DocNameLabel.backgroundColor = .systemMint
        //        DocDateLabel.backgroundColor = .systemYellow
    }
    
    public func configure(with viewModel: NSHistoryCollectionViewCellViewModel) {
        // TODO: - Add viewModel config
        DocNameLabel.text = viewModel.docName.trimmingCharacters(in: .whitespacesAndNewlines)

        DocDateLabel.text = viewModel.docDate
        // TODO: - image loader
        viewModel.fetchImage { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.DocimageView.image = image
                }
            case .failure(let error):
                print(String(describing: error))
                break
            }
        }
    }
}
