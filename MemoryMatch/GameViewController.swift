import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Настройка SpriteKit вью
        let skView = SKView(frame: self.view.bounds)
        skView.ignoresSiblingOrder = true
        self.view.addSubview(skView)

        // Создание и запуск сцены загрузки
        let scene = LoadingScene(size: skView.bounds.size)
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
