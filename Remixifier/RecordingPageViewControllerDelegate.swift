//
//  RecordingListDelegate.swift
//  Remixifier
//
//  Created by Christian Gonzalez on 1/16/16.
//  Copyright © 2016 Christian Gonzalez. All rights reserved.
//

import Foundation
import UIKit
protocol RecordingPageViewControllerDelegate: class {
    func recordPageViewController(controller: RecordPageViewController, didFinishAddingClip mission: Clip)
//    func missionDetailsViewController(controller: ClipDetailViewController, didFinishEditingClip mission: Clip)
}