//
//  LayoutConfiguration.swift
//  RxPhotoPickerView
//
//  Created by Siddharthan Asokan on 3/17/18.
//  Copyright © 2018 sid. All rights reserved.
//

import UIKit

public protocol CustomLayoutConfiguration {
    var numberOfSegments: Int { get set }
    var isHorizontal: Bool { get set }
    var numberOfImages: Int { get set }
}

public struct DefaultConfiguration: CustomLayoutConfiguration {
    public init() {}

    public var numberOfSegments: Int = 3

    public var isHorizontal: Bool = false

    public var numberOfImages: Int = 10
}
