import Foundation
import AVFoundation
import AudioToolbox

final class SoundManager {
    static let shared = SoundManager()

    var soundEnabled: Bool
    var vibrationEnabled: Bool

    private var matchSound: AVAudioPlayer?
    private var flipSound: AVAudioPlayer?
    private var winSound: AVAudioPlayer?

    private init() {
        soundEnabled = UserDefaults.standard.bool(forKey: "sound_enabled")
        vibrationEnabled = UserDefaults.standard.bool(forKey: "vibration_enabled")
        loadSounds()
    }

    private func loadSounds() {
        matchSound = loadSound(named: "match")
        flipSound = loadSound(named: "flip")
        winSound = loadSound(named: "win")
    }

    private func loadSound(named: String) -> AVAudioPlayer? {
        guard let url = Bundle.main.url(forResource: named, withExtension: "wav") else {
            print("❌ Sound file \(named).wav not found.")
            return nil
        }
        return try? AVAudioPlayer(contentsOf: url)
    }

    func playMatch() {
        guard soundEnabled else { return }
        matchSound?.play()
    }

    func playFlip() {
        guard soundEnabled else { return }
        flipSound?.play()
    }

    func playWin() {
        guard soundEnabled else { return }
        winSound?.play()
    }

    func vibrate() {
        guard vibrationEnabled else { return }
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }

    // Эти методы можно вызывать из настроек
    func updateSound(_ isOn: Bool) {
        soundEnabled = isOn
        UserDefaults.standard.set(isOn, forKey: "sound_enabled")
    }

    func updateVibration(_ isOn: Bool) {
        vibrationEnabled = isOn
        UserDefaults.standard.set(isOn, forKey: "vibration_enabled")
    }
}
