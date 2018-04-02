//
//  LayoutConfiguration.swift
//  RxPhotoPickerView
//
//  Created by Siddharthan Asokan on 3/17/18.
//  Copyright © 2018 sid. All rights reserved.
//

import UIKit

protocol CustomLayoutConfiguration {
    var numberOfSegments: Int { get set }
    var isHorizontal: Bool { get set }
    var numberOfImages: Int { get set }
    var imagesModels: [ImageIndexModel] { get set }
}

struct DefaultConfiguration: CustomLayoutConfiguration {
    init() {}

    var numberOfSegments: Int = 3

    var isHorizontal: Bool = false

    var numberOfImages: Int = 10

    var imagesModels: [ImageIndexModel] = []
}

struct ImageIndexModel {
    var index: Int = 0
    var image: UIImage?
    var assetIdentifier: String?
}
