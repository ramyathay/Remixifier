//
//  CancelButton.swift
//  Remixifier
//
//  Created by Christian Gonzalez on 1/15/16.
//  Copyright © 2016 Christian Gonzalez. All rights reserved.
//

import Foundation
import UIKit

protocol CancelButtonDelegate: class {
    func cancelButtonPressedFrom(controller: UIViewController)
}