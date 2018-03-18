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

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView()
        imageView?.contentMode = .scaleAspectFit
        imageView?.isUserInteractionEnabled = false

        indexLabel = UILabel()

        guard let imageView = imageView, let indexLabel = indexLabel else {
            assertionFailure("Invalid Image View. Imagepicker needs a image view inside its cell")
            return
        }

        contentView.addSubview(imageView)
        contentView.addSubview(indexLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if let imageView = imageView {
            var frame = imageView.frame
            frame.size.height = self.frame.size.height
            frame.size.width = self.frame.size.width
            frame.origin.x = 0
            frame.origin.y = 0
            imageView.frame = frame
        }

        if let indexLabel = indexLabel {
            var frame = indexLabel.frame
            frame.size.height = self.frame.size.height
            frame.size.width = self.frame.size.width
            frame.origin.x = 0
            frame.origin.y = 0
            indexLabel.frame = frame
        }
    }

    func configure(_ model: UIImage?) {
        imageView?.image = model
    }

    func updateText(index: Int) {
        indexLabel?.text = "\(index)"
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
