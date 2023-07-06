//
//  NSHistoryDetailView.swift
//  NoteSum
//
//  Created by Yuxuan Wu on 4/5/23.
//

import UIKit

final class NSHistoryDetailView: UIView, UITextViewDelegate {
    
    
    private let viewModel: NSHistoryDetailViewViewModel
    private let padding: CGFloat = 16
    
    /// Doc Image (Image)
    private let DetailDocimageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    let DetailDocTextView: UITextView = {
        let textView = UITextView()
        textView.contentMode = .scaleAspectFill
        textView.clipsToBounds = true
        textView.translatesAutoresizingMaskIntoConstraints = false
//        textView.insertText("None")
        textView.backgroundColor = UIColor.secondarySystemBackground
        textView.layer.cornerRadius = 16
        textView.layer.shadowColor = UIColor.systemBackground.cgColor
        textView.layer.shadowOffset = CGSize(width: 0, height: 0)
        textView.layer.shadowOpacity = 0.5
        textView.layer.shadowRadius = 16
        textView.backgroundColor = UIColor.secondarySystemBackground.withAlphaComponent(0.8)
        return textView
    }()
    
    init(frame: CGRect, viewModel: NSHistoryDetailViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        
        // setup the image
        addSubviews(DetailDocimageView, DetailDocTextView)
        addConstraints()
        configure(with: viewModel)
        // Set delegate for DetailDocTextView
        DetailDocTextView.delegate = self
    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if superview != nil {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }

    override func removeFromSuperview() {
        super.removeFromSuperview()
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            DetailDocTextView.contentInset = insets
            DetailDocTextView.scrollIndicatorInsets = insets
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
        let insets = UIEdgeInsets.zero
        DetailDocTextView.contentInset = insets
        DetailDocTextView.scrollIndicatorInsets = insets
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            DetailDocimageView.heightAnchor.constraint(equalToConstant: 200),
            DetailDocimageView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding),
            DetailDocimageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding),
            DetailDocimageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            
//            DetailDocTextView.heightAnchor.constraint(equalToConstant: 100),
            DetailDocTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding),
            DetailDocTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding),
            DetailDocTextView.topAnchor.constraint(equalTo: DetailDocimageView.bottomAnchor, constant: padding),
            DetailDocTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    
    public func configure(with viewModel: NSHistoryDetailViewViewModel) {
        DetailDocTextView.text = viewModel.getDescription()
        // TODO: - image loader
        viewModel.fetchImage { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.DetailDocimageView.image = image
                }
            case .failure(let error):
                print(String(describing: error))
                break
            }
        }
    }
}
