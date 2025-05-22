import UIKit
import SpriteKit

class YouWinViewController: UIViewController {
    
    private let moves: Int
    private let time: Int
    
    init(moves: Int, time: Int) {
        self.moves = moves
        self.time = time
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupWinImage()
        setupWinContainer()
        setupButtons()
    }

    // MARK: - Фон
    private func setupBackground() {
        // 1. Фон GamePlay
        let gameBg = UIImageView(image: UIImage(named: "GamePlay"))
        gameBg.contentMode = .scaleAspectFill
        gameBg.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gameBg)
        // 2. Затемнение
        let overlay = UIView()
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlay.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlay)
        // 3. BG21 поверх
        let bg21 = UIImageView(image: UIImage(named: "BGParallax3"))
        bg21.contentMode = .scaleAspectFill
        bg21.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bg21)
        // Constraints
        [gameBg, overlay, bg21].forEach {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: view.topAnchor),
                $0.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                $0.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }
    }

    // MARK: - Надпись Youwin
    private func setupWinImage() {
        guard let winImage = UIImage(named: "Youwin") else {
            print("❌ Image 'Youwin' not found")
            return
        }

        let winImageView = UIImageView(image: winImage)
        winImageView.contentMode = .scaleAspectFit
        winImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(winImageView)

        // Размер
        let designWidth: CGFloat = 1088
        let designHeight: CGFloat = 2532
        let figmaTop: CGFloat = 519
        let figmaLeft: CGFloat = 44
        let figmaWidth: CGFloat = 1000
        let figmaHeight: CGFloat = 1000

        //  Переводим в пропорции
        let topRatio = figmaTop / designHeight
        let leftRatio = figmaLeft / designWidth
        let widthRatio = figmaWidth / designWidth
        let heightRatio = figmaHeight / designHeight

        NSLayoutConstraint.activate([
            winImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * topRatio),
            winImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * leftRatio),
            winImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: widthRatio),
            winImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: heightRatio)
        ])

        // Анимация появления
        winImageView.alpha = 0
        UIView.animate(withDuration: 0.5) {
            winImageView.alpha = 1
        }
    }
    // MARK: - Статистика (Frame1)
    private func setupWinContainer() {
        // Frame1 фон
        let frameImage = UIImageView(image: UIImage(named: "Frame1"))
        frameImage.contentMode = .scaleAspectFit
        frameImage.translatesAutoresizingMaskIntoConstraints = false
       
        if let youwinView = view.subviews.first(where: {
            ($0 as? UIImageView)?.image == UIImage(named: "Youwin")
        }) {
            view.insertSubview(frameImage, belowSubview: youwinView)
        } else {
            view.addSubview(frameImage)
        }
        // TIME
        let timeLabel = UILabel()
        timeLabel.text = "TIME\n\(time)s"
        timeLabel.numberOfLines = 2
        timeLabel.textAlignment = .center
        timeLabel.font = UIFont(name: "AvenirNext-Bold", size: 20)
        timeLabel.textColor = .white
        timeLabel.translatesAutoresizingMaskIntoConstraints = false

        // MOVES
        let movesLabel = UILabel()
        movesLabel.text = "MOVES\n\(moves)"
        movesLabel.numberOfLines = 2
        movesLabel.textAlignment = .center
        movesLabel.font = UIFont(name: "AvenirNext-Bold", size: 20)
        movesLabel.textColor = .white
        movesLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(timeLabel)
        view.addSubview(movesLabel)

        NSLayoutConstraint.activate([
            frameImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            frameImage.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 5),
            frameImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            frameImage.heightAnchor.constraint(equalTo: frameImage.widthAnchor, multiplier: 0.5),

            timeLabel.centerXAnchor.constraint(equalTo: frameImage.centerXAnchor, constant: -80),
            timeLabel.centerYAnchor.constraint(equalTo: frameImage.centerYAnchor),

            movesLabel.centerXAnchor.constraint(equalTo: frameImage.centerXAnchor, constant: 80),
            movesLabel.centerYAnchor.constraint(equalTo: frameImage.centerYAnchor)
        ])

        // Анимация появления
        frameImage.alpha = 0
        frameImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        timeLabel.alpha = 0
        movesLabel.alpha = 0

        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut) {
            frameImage.alpha = 1
            frameImage.transform = .identity
            timeLabel.alpha = 1
            movesLabel.alpha = 1
        }
    }

    // MARK: - Кнопки
    private func setupButtons() {
        // Контейнер StackView
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 0.5
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        // Кнопка "UndoBack"
        let playAgain = UIButton(type: .custom)
        playAgain.setImage(UIImage(named: "UndoBack"), for: .normal)
        playAgain.imageView?.contentMode = .scaleAspectFit
        playAgain.translatesAutoresizingMaskIntoConstraints = false
        playAgain.addTarget(self, action: #selector(playAgainTapped), for: .touchUpInside)

        // Кнопка "Menu"
        let menu = UIButton(type: .custom)
        menu.setImage(UIImage(named: "Menu"), for: .normal)
        menu.imageView?.contentMode = .scaleAspectFit
        menu.translatesAutoresizingMaskIntoConstraints = false
        menu.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)

        // Добавляем в StackView
        stack.addArrangedSubview(playAgain)
        stack.addArrangedSubview(menu)

        // Добавим stack в центр
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 189),

            playAgain.widthAnchor.constraint(equalToConstant: 120),
            playAgain.heightAnchor.constraint(equalToConstant: 50),

            menu.widthAnchor.constraint(equalToConstant: 120),
            menu.heightAnchor.constraint(equalToConstant: 50)
        ])

        // Анимация появления
        stack.alpha = 0
        stack.transform = CGAffineTransform(translationX: 0, y: 30)
        UIView.animate(withDuration: 0.5,
                       delay: 0.6,
                       options: .curveEaseOut) {
            stack.alpha = 1
            stack.transform = .identity
        }
    }

    // MARK: - Действия кнопок
    @objc private func playAgainTapped() {
        dismiss(animated: true) {
            if let window = UIApplication.shared.windows.first {
                let gameVC = UIViewController()
                let skView = SKView(frame: window.bounds)
                gameVC.view = skView
                window.rootViewController = gameVC

                let scene = GameScene(size: skView.bounds.size)
                scene.scaleMode = .aspectFill
                skView.presentScene(scene)
            }
        }
    }

    @objc private func menuTapped() {
        dismiss(animated: true) {
            if let window = UIApplication.shared.windows.first {
                let menuVC = MenuViewController()
                window.rootViewController = menuVC
            }
        }
    }
}
