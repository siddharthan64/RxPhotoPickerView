//
//  GridViewCell.swift
//  RxPhotoPickerView
//
//  Created by Siddharthan Asokan on 3/18/18.
//  Copyright © 2018 sid. All rights reserved.
//

import UIKit

class GridViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        _ = imageView
        _ = selectionView
        _ = indexLabel
        setUp()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    lazy var selectionView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = UIColor(red: 102/255.0, green: 204/255.0, blue: 0/255.0, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var indexLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    private func setUp() {
        addSubview(imageView)
        imageView.addSubview(selectionView)
        selectionView.addSubview(indexLabel)

        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true

        selectionView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 5).isActive = true
        selectionView.rightAnchor.constraint(equalTo: imageView.rightAnchor, constant: -5).isActive = true
        selectionView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        selectionView.heightAnchor.constraint(equalToConstant: 30).isActive = true

        indexLabel.heightAnchor.constraint(equalTo: selectionView.heightAnchor).isActive = true
        indexLabel.widthAnchor.constraint(equalTo: selectionView.widthAnchor).isActive = true
        indexLabel.centerXAnchor.constraint(equalTo: selectionView.centerXAnchor).isActive = true
        indexLabel.centerYAnchor.constraint(equalTo: selectionView.centerYAnchor).isActive = true
    }

    var thumbnailImage: UIImage! {
        didSet {
            imageView.image = thumbnailImage
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImage = nil
        selectionView.isHidden = true
    }

    func configureCell(_ model: SelectionModel) {
        thumbnailImage = model.image
        selectionView.isHidden = !model.isSelected
        if let index = model.imageIndex, model.isSelected {
            indexLabel.text = "\(index)"
        }
    }
}
