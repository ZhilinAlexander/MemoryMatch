import SpriteKit

class LoadingScene: SKScene {

    private var fireNode: SKSpriteNode!
    private var background: SKSpriteNode!

    override func didMove(to view: SKView) {
        configureBackground()
        configureFireNode()
        animateFire()
        // Переход к следующему экрану через 3 секунды
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.navigateToMenu()
        }
    }
    // Фон
    private func configureBackground() {
        background = SKSpriteNode(imageNamed: "Splash")
        background.size = size
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1
        addChild(background)
    }
    // Огонь
    private func configureFireNode() {
        fireNode = SKSpriteNode(imageNamed: "fire")
        let fireScale = min(size.width, size.height) / 1200
        fireNode.setScale(fireScale)
        fireNode.position = CGPoint(x: size.width / 2, y: size.height * 0.75)
        fireNode.zPosition = 1
        addChild(fireNode)
    }
    private func animateFire() {
        let moveUp = SKAction.moveBy(x: 0, y: 15, duration: 0.5)
        let moveDown = moveUp.reversed()
        let sequence = SKAction.sequence([moveUp, moveDown])
        fireNode.run(SKAction.repeatForever(sequence))
    }
    // Переход
    private func navigateToMenu() {
         let menuVC = MenuViewController()
        view?.window?.rootViewController = menuVC
    }
}
