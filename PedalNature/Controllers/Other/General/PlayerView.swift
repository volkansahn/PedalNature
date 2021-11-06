//
//  PlayerView.swift
//  PedalNature
//
//  Created by Volkan on 31.10.2021.
//

import AVFoundation
import UIKit
import AVFoundation
import UIKit

class PlayerView: UIView {

    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }

    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }

    // Override UIView property
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
