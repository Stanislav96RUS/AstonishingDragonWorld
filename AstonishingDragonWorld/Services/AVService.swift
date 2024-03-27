//
//  AVService.swift
//  AstonishingDragonWorld
//
//  Created by Stanislav on 23.03.2024.
//

import AVFoundation
import Foundation

private extension String {
    static let mp3 = "mp3"
}

final class AVService {
    
    var player: AVAudioPlayer!
    
    func playSound(_ sound:String) {
        let url = Bundle.main.url(forResource: sound, withExtension: .mp3)
        player = try! AVAudioPlayer(contentsOf: url!)
        player!.play()
    }
}
