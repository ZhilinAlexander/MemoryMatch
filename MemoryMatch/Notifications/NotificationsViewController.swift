import UIKit

class NotificationsViewController: UIViewController {

    private let bonusButton = UIButton(type: .custom)
    private let skipButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupBottomOverlay()
        setupLogo()
        setupButtons()
        setupTexts(above: bonusButton)
    }

    // MARK: - Фон
    private func setupBackground() {
        let bgImageView = UIImageView(image: UIImage(named: "splashbackground"))
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bgImageView)

        NSLayoutConstraint.activate([
            bgImageView.topAnchor.constraint(equalTo: view.topAnchor),
            bgImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bgImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bgImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupLogo() {
        let logoImageView = UIImageView(image: UIImage(named: "Logo"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 400),
            logoImageView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    private func setupBottomOverlay() {
        let overlayImageView = UIImageView(image: UIImage(named: "Group352075"))
        overlayImageView.contentMode = .scaleAspectFill
        overlayImageView.translatesAutoresizingMaskIntoConstraints = false
        if let background = view.subviews.first {
            view.insertSubview(overlayImageView, aboveSubview: background)
        } else {
            view.addSubview(overlayImageView)
        }
        NSLayoutConstraint.activate([
            overlayImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlayImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            overlayImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            overlayImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    // MARK: - Кнопки
        private func setupButtons() {
            // ✅ Кнопка "Yes, I Want Bonuses!"
            bonusButton.setBackgroundImage(UIImage(named: "Rectangle2"), for: .normal)
            bonusButton.setTitle("Yes, I Want Bonuses!", for: .normal)
            bonusButton.setTitleColor(.black, for: .normal)
            bonusButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 19)
            bonusButton.titleLabel?.textAlignment = .center
            bonusButton.contentVerticalAlignment = .center
            bonusButton.contentHorizontalAlignment = .center
            bonusButton.layer.cornerRadius = 12
            bonusButton.layer.masksToBounds = true
            bonusButton.translatesAutoresizingMaskIntoConstraints = false
            bonusButton.addTarget(self, action: #selector(bonusTapped), for: .touchUpInside)
            view.addSubview(bonusButton)

            // Кнопка "Skip"
            skipButton.setTitle("Skip", for: .normal)
            skipButton.setTitleColor(.white, for: .normal)
            skipButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 18)
            skipButton.translatesAutoresizingMaskIntoConstraints = false
            skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
            view.addSubview(skipButton)

            NSLayoutConstraint.activate([
                bonusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                bonusButton.widthAnchor.constraint(equalToConstant: 330),
                bonusButton.heightAnchor.constraint(equalToConstant: 60),
                bonusButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),

                skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                skipButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
            ])
        }
    // MARK: тексты
    private func setupTexts(above button: UIView) {
        let titleLabel = UILabel()
        titleLabel.text = "ALLOW NOTIFICATIONS ABOUT BONUSES AND PROMOS"
        titleLabel.font = UIFont(name: "Inter-Bold", size: 32) // Адаптированная высота
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let subtitleLabel = UILabel()
        subtitleLabel.text = "Stay tuned with best offers from\nour casino"
        subtitleLabel.font = UIFont(name: "Inter-Medium", size: 24)
        subtitleLabel.textColor = .white
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)

        NSLayoutConstraint.activate([
            subtitleLabel.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -60),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),

            titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: -20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
        ])
    }

    // MARK: - Действия
    @objc private func bonusTapped() {
        print("🎁 Bonus tapped")
        dismiss(animated: true)
    }

    @objc private func skipTapped() {
        print("⏭️ Skipped")
        dismiss(animated: true)
    }
}

