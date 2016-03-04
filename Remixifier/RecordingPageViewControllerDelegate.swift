//
//  RecordingListDelegate.swift
//  Remixifier


import Foundation
import UIKit
protocol RecordingPageViewControllerDelegate: class {
    func recordPageViewController(controller: RecordPageViewController, didFinishAddingClip mission: Clip)
}