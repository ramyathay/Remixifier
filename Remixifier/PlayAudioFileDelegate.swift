//
//  PlayAudioFileDelegate.swift
//  remixTest
//
//  Created by Ramyatha Yugendernath on 1/18/16.
//  Copyright © 2016 Ramyatha Yugendernath. All rights reserved.
//

import Foundation

protocol PlayAudioFileDelegate: class {
    func audioFileDetails(controller: PlayAudioClipViewController,didFinishSelectingAudioFiles audioClip: [String])
}