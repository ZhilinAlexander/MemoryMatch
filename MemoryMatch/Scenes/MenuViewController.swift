import UIKit
import SpriteKit
import SafariServices

class MenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupButtons()
    }
         //  Фон
    private func setupBackground() {
        // 1. BG_1 (основной фон)
        let bg1ImageView = UIImageView(image: UIImage(named: "BG_1"))
        bg1ImageView.contentMode = .scaleAspectFill
        bg1ImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bg1ImageView)
        // 2. BG2
        let parallaxImageView = UIImageView(image: UIImage(named: "BG2"))
        parallaxImageView.contentMode = .scaleAspectFill
        parallaxImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(parallaxImageView)
        // 3. Menuicon1
        let iconImageView = UIImageView(image: UIImage(named: "Menuicon1"))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(iconImageView)
        // Упорядочим слои
        view.sendSubviewToBack(bg1ImageView)
        // Layout
        NSLayoutConstraint.activate([
            // BG_1
            bg1ImageView.topAnchor.constraint(equalTo: view.topAnchor),
            bg1ImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bg1ImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bg1ImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // BG2
            parallaxImageView.topAnchor.constraint(equalTo: view.topAnchor),
            parallaxImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            parallaxImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            parallaxImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // Menu_icon
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -view.bounds.height * 0.2),
            iconImageView.widthAnchor.constraint(equalToConstant: 240),
            iconImageView.heightAnchor.constraint(equalToConstant: 240)
        ])
    }
    // Кнопки
    private func setupButtons() {
        // 1️⃣ PLAY NOW
        let playButton = UIButton(type: .custom)
        playButton.setImage(UIImage(named: "PlayNow"), for: .normal)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        view.addSubview(playButton)
        // 2️⃣ PRIVACY POLICY
        let policyButton = UIButton(type: .custom)
        policyButton.setImage(UIImage(named: "PrivacyPolicy"), for: .normal)
        policyButton.translatesAutoresizingMaskIntoConstraints = false
        policyButton.addTarget(self, action: #selector(openPrivacyPolicy), for: .touchUpInside)
        view.addSubview(policyButton)
       
        NSLayoutConstraint.activate([
            // PLAY NOW
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 228),
            playButton.heightAnchor.constraint(equalToConstant: 60),
            // PRIVACY POLICY 
            policyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            policyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.bounds.height * 0.2),
            policyButton.widthAnchor.constraint(equalToConstant: 200),
            policyButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    @objc private func openPrivacyPolicy() {
            guard let url = URL(string: "https://www.linkedin.com/in/alexanderzhilin/privacy/") else { return }
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true)
        }
    // кнопоки
    @objc private func startGame() {
        let skView = SKView(frame: view.bounds)
        view.addSubview(skView)
        
        let scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        
        let transition = SKTransition.fade(withDuration: 1.0)
        skView.presentScene(scene, transition: transition)
    }
    
}

