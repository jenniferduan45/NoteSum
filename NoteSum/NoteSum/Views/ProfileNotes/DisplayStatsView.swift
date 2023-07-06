//
//  DisplayStatsView.swift
//  NoteSum
//
//  Created by Isabelle Arevalo on 4/4/23.
//

import UIKit

class DisplayStatsView: UIView {

    let label1 = UILabel()
    let label2 = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }

    private func configureView() {
        // Set up the view's appearance
        backgroundColor = .white
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 5.0

        // Set up the first label
        label1.numberOfLines = 0
        label1.text = "Label 1"
        label1.textAlignment = .center

        // Set up the second label
        label2.numberOfLines = 0
        label2.text = "Label 2"
        label2.textAlignment = .center

        // Add the labels to the view
        addSubview(label1)
        addSubview(label2)

        // Set up constraints
        label1.translatesAutoresizingMaskIntoConstraints = false
        label2.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label1.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            label1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            label1.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            label2.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 8),
            label2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            label2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            label2.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}
