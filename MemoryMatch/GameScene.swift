import SpriteKit
import AVFoundation
import AudioToolbox

class GameScene: SKScene {
    
    //  Переменные игры
    private var firstCard: SKSpriteNode?
    private var isProcessing = false
    private var isGameActive = true
    private var moves = 0
    private var startTime: TimeInterval = 0
    private var timerLabel: SKLabelNode!
    private var moveLabel: SKLabelNode!
    private var cardNodes: [SKSpriteNode] = []
    //фонблока
    private var statsBackground: SKShapeNode!
    // Настройки
    override func didMove(to view: SKView) {
        isGameActive = true
        setupBackground()
        setupUI()
        setupStatsHeader()  //табло счета и таймера
        setupCards()
        startTime = CACurrentMediaTime()
    }
    // Фон
    private func setupBackground() {
        let bg = SKSpriteNode(imageNamed: "BGgames")
        bg.position = CGPoint(x: size.width / 2, y: size.height / 2)
        bg.size = size
        bg.zPosition = -1
        addChild(bg)
    }
    // UI интерфейс: кнопки, таймер, ходы
    private func setupUI() {
        // Нижние кнопки (Pause, Left, Undo)
        let spacingX = size.width / 4
        let bottomY = size.height * 0.10
        
        let pause = createButton(named: "Pause", position: CGPoint(x: spacingX * 0.75, y: bottomY))
        let left  = createButton(named: "Left",  position: CGPoint(x: spacingX * 2.0, y: bottomY))
        let undo  = createButton(named: "Undo",  position: CGPoint(x: spacingX * 3.25, y: bottomY))
        
        addChild(pause)
        addChild(left)
        addChild(undo)

        // Кнопка Settings — вверху слева 
        let settings = createButton(named: "Settings", position: CGPoint(
            x: size.width * 0.11,  // от левого края экрана
            y: size.height * 0.9   //  от низа (выше табло)
        ))
        addChild(settings)
    }
    private func setupStatsHeader() {
        

        let headerWidth = size.width * 0.9
        let headerHeight = headerWidth * (120.0 / 973.0)
        let topMargin = size.height * 0.80
        
        let statsNode = SKSpriteNode(imageNamed: "Group352519")
        statsNode.size = CGSize(width: headerWidth, height: headerHeight)
        statsNode.position = CGPoint(x: size.width / 2, y: topMargin)
        statsNode.zPosition = 2
        addChild(statsNode)
        
        statsNode.name = "StatsHeader"
        
        // Move Label
        moveLabel = SKLabelNode(text: "Moves: 0")
           moveLabel.fontName = "AvenirNext-Bold"
           moveLabel.fontColor = .white
           moveLabel.horizontalAlignmentMode = .left
           moveLabel.verticalAlignmentMode = .center
           moveLabel.position = CGPoint(x: -headerWidth / 2 + 40, y: 0)
           statsNode.addChild(moveLabel)
        // Timer Label — справа
        timerLabel = SKLabelNode(text: "Time: 0s")
            timerLabel.fontName = "AvenirNext-Bold"
            timerLabel.fontColor = .white
            timerLabel.horizontalAlignmentMode = .right
            timerLabel.verticalAlignmentMode = .center
            timerLabel.position = CGPoint(x: headerWidth / 2 - 40, y: 0)
            statsNode.addChild(timerLabel)

        // Масштаб шрифта для малых экранов
            let isSmallDevice = size.height < 700
            let fontSize: CGFloat = isSmallDevice ? 18 : 24
            moveLabel.fontSize = fontSize
            timerLabel.fontSize = fontSize
    }
    private func createLabel(text: String, position: CGPoint) -> SKLabelNode {
        let label = SKLabelNode(text: text)
        label.fontName = "AvenirNext-Bold"
        label.fontSize = 24
        label.fontColor = .white
        label.position = position
        label.zPosition = 2
        return label
    }
    private func createButton(named: String, position: CGPoint) -> SKSpriteNode {
        let btn = SKSpriteNode(imageNamed: named)
        btn.name = named
        btn.position = position
        btn.setScale(0.4)
        btn.zPosition = 2
        return btn
    }
    // Карточки
    private func setupCards() {
        let isSmallDevice = size.height < 700
        // Названия слотов, по 2 каждого → 8 пар = 16 карт
        let faceNames = (1...8).flatMap { ["Slot\($0)", "Slot\($0)"] }.shuffled()

           let rows = 4, cols = 4
           let spacing: CGFloat = isSmallDevice ? 12 : 20
           let cardWidth = size.width * (isSmallDevice ? 0.16 : 0.18)
           let cardHeight = cardWidth * 1.2

           let totalWidth = CGFloat(cols) * cardWidth + CGFloat(cols - 1) * spacing
           let totalHeight = CGFloat(rows) * cardHeight + CGFloat(rows - 1) * spacing

           let startX = (size.width - totalWidth) / 2 + cardWidth / 2
           let startY = size.height / 2 + totalHeight / 2 - cardHeight / 2

           for row in 0..<rows {
               for col in 0..<cols {
                   let index = row * cols + col

                // Карта
                let card = SKSpriteNode(imageNamed: "SlotBack")
                card.name = "card_\(index)"
                card.size = CGSize(width: cardWidth, height: cardHeight)
                card.position = CGPoint(
                    x: startX + CGFloat(col) * (cardWidth + spacing),
                    y: startY - CGFloat(row) * (cardHeight + spacing)
                )
                card.zPosition = 1
                
                // Добавим в userData: face (название картинки)перемешиваются карты
                card.userData = [
                    "face": faceNames[index],
                    "flipped": false,
                    "matched": false
                ]
                
                addChild(card)
                cardNodes.append(card)
            }
        }
    }
    //  Таймер
    override func update(_ currentTime: TimeInterval) {
        guard isGameActive else { return }
        let seconds = Int(currentTime - startTime)
        timerLabel.text = "Time: \(seconds)s"
    }
    // Обработка касаний
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isProcessing, let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if let node = atPoint(location) as? SKSpriteNode, let name = node.name {
            
            let animatedButtons = ["Settings", "Pause", "Undo", "Left"]
            
            if animatedButtons.contains(name) {
                let dim = SKAction.fadeAlpha(to: 0.6, duration: 0.05)
                let restore = SKAction.fadeAlpha(to: 1.0, duration: 0.05)
                let sequence = SKAction.sequence([dim, restore])
                node.run(sequence) {
                    self.handleButtonTap(name)
                }
            } else if name.starts(with: "card_") {
                handleCardTap(node)
            } else {
                handleButtonTap(name)
            }
        }
    }

    // Логика нажатия на карту
    private func handleCardTap(_ card: SKSpriteNode) {
       if !isGameActive {
           isGameActive = true
        }
        guard let face = card.userData?["face"] as? String,
              card.userData?["matched"] as? Bool == false,
              card.userData?["flipped"] as? Bool == false else { return }
        
        flipCard(card, to: face)
        card.userData?["flipped"] = true
        
        if firstCard == nil {
            firstCard = card
        } else {
            isProcessing = true
            moves += 1
            moveLabel.text = "Moves: \(moves)"
            
            if firstCard?.userData?["face"] as? String == face {
                // Совпадение
                firstCard?.userData?["matched"] = true
                card.userData?["matched"] = true
                SoundManager.shared.playMatch()  
                            SoundManager.shared.vibrate()
                checkForWin()
                resetSelection()
            } else {
                // Не совпало — переворачиваем обратно
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    self.flipCard(self.firstCard!, to: "SlotBack")
                    self.firstCard?.userData?["flipped"] = false
                    self.flipCard(card, to: "SlotBack")
                    card.userData?["flipped"] = false
                    self.resetSelection()
                }
            }
        }
    }
    // пауза - ручная остановка
    private func handleButtonTap(_ name: String) {
        switch name {
        case "Pause":
            isGameActive.toggle()
            print("⏸ Pause pressed. Game is now \(isGameActive ? "resumed" : "paused")")
            
        case "Undo":
            reloadGame()
            
        case "Left":
            goToMenu()
            
        case "Settings":
            openSettings()
            
        default:
            print("Unknown button: \(name)")
        }
    }
    private func resetSelection() {
        firstCard = nil
        isProcessing = false
    }
    
    private func flipCard(_ card: SKSpriteNode, to name: String) {
        let flip = SKAction.sequence([
            SKAction.scaleX(to: 0, duration: 0.15),
            SKAction.run {
                SoundManager.shared.playFlip()
                card.texture = SKTexture(imageNamed: name)
            },
            SKAction.scaleX(to: 1, duration: 0.15)
        ])
        card.run(flip)
    }
    //  Победа
    private func checkForWin() {
        let allMatched = cardNodes.allSatisfy { $0.userData?["matched"] as? Bool == true }
        if allMatched {
            isGameActive = false  // Остановка таймера
            showWinScreen()
        }
    }
    // перезапуск игры
    private func reloadGame() {
        if let view = self.view {
            let newScene = GameScene(size: self.size)
            newScene.scaleMode = .aspectFill
            view.presentScene(newScene, transition: .fade(withDuration: 0.5))
        }
    }
    // переход в меню
    private func goToMenu() {
        if let window = view?.window {
            let menuVC = MenuViewController()
            window.rootViewController = menuVC
            window.makeKeyAndVisible()
        }
    }
    // переход в настройки
    private func openSettings() {
        guard let view = self.view,
              let root = view.window?.rootViewController else { return }
        
        let settingsVC = SettingsViewController()
        settingsVC.modalPresentationStyle = .overFullScreen
        root.present(settingsVC, animated: true)
    }
    // переход на экран Win
    private func showWinScreen() {
        let movesCount = moves
        let timeElapsed = Int(CACurrentMediaTime() - startTime)
        
        SoundManager.shared.playWin()
        SoundManager.shared.vibrate()
        
        let winVC = YouWinViewController(moves: movesCount, time: timeElapsed)
        winVC.modalPresentationStyle = .fullScreen
        
        if let root = view?.window?.rootViewController {
            root.present(winVC, animated: true)
        }
    }
}
