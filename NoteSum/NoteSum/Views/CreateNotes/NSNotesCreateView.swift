//
//  NSNotesCreateView.swift
//  NoteSum
//
//  Created by Jennifer Duan on 4/11/23.
//

import UIKit

/// General View for creating notes summary
class NSNotesCreateView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    // MARK: - Init
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        stackView.addArrangedSubview(cameraButton)
        stackView.addArrangedSubview(photoButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(stackView)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal let cameraButton: UIButton = {
        let camera = UIButton()
        camera.backgroundColor = UIColor.systemBlue
        camera.setTitle("Take a picture", for: .normal)
        camera.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        camera.widthAnchor.constraint(equalToConstant: 300.0).isActive = true
        return camera
    }()
    
    public let photoButton: UIButton = {
        let photo = UIButton()
        photo.backgroundColor = UIColor.systemBlue
        photo.setTitle("Upload a photo", for: .normal)
        photo.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        photo.widthAnchor.constraint(equalToConstant: 300.0).isActive = true
        return photo
    }()
    
    
    public let stackView: UIStackView = {
        let stackView   = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.vertical
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 50.0
        return stackView
    }()
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalToConstant: 300),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

}
