//
//  RxCollectionViewCell.swift
//  RxImagePicker
//
//  Created by Siddharthan Asokan on 3/10/18.
//  Copyright © 2018 sid. All rights reserved.
//

import UIKit

class RxCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView?

    var indexLabel: UILabel?

    static let cellIdentifier = "Cell"

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
        contentView.backgroundColor = .lightGray
        indexLabel?.isHidden = false
    }

    func setup() {
        imageView = UIImageView()
        imageView?.contentMode = .scaleAspectFill
        imageView?.clipsToBounds = true
        imageView?.isUserInteractionEnabled = false

        if let imageView = imageView {
            contentView.addSubview(imageView)

            imageView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            ])
        }

        indexLabel = UILabel()

        if let indexLabel = indexLabel {
            contentView.addSubview(indexLabel)

            indexLabel.translatesAutoresizingMaskIntoConstraints = false
            indexLabel.font = UIFont.systemFont(ofSize: 35, weight: .medium)
            indexLabel.textAlignment = .center
            indexLabel.textColor = .white

            NSLayoutConstraint.activate([
                indexLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                indexLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                indexLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.75),
                indexLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.75),
            ])
        }
    }

    func configure(image: UIImage?) {
        imageView?.image = image
        indexLabel?.isHidden = image == nil ? false : true
        contentView.backgroundColor = .black
    }

    func updateText(index: Int) {
        indexLabel?.text = "\(index)"
        contentView.backgroundColor = .lightGray
    }
}
