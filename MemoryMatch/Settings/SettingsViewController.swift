import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - UI элементы
    private let soundSwitch = UISwitch()
    private let vibrationSwitch = UISwitch()
    private let stackView = UIStackView()
    private let closeButton = UIButton(type: .system)
    // цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupInitialValues()
    }
    private func setupViews() {
        // Background
        let background = UIImageView(image: UIImage(named: "Notifications"))
        background.contentMode = .scaleAspectFill
        background.clipsToBounds = true
        background.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(background)
        view.sendSubviewToBack(background)
        // Добавляем constraints для фона
           NSLayoutConstraint.activate([
               background.topAnchor.constraint(equalTo: view.topAnchor),
               background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
               background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               background.trailingAnchor.constraint(equalTo: view.trailingAnchor)
           ])
        // соунд UI
        let soundLabel = UILabel()
        soundLabel.text = "Sound"
        soundLabel.textColor = .white
        // вибрация UI
        let vibrationLabel = UILabel()
        vibrationLabel.text = "Vibration"
        vibrationLabel.textColor = .white
        // Stack View
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(createSettingRow(label: soundLabel, toggle: soundSwitch))
        stackView.addArrangedSubview(createSettingRow(label: vibrationLabel, toggle: vibrationSwitch))
        
        // Кнопка бонусов (Yes, I Want Bonuses!)
        let bonusButton = UIButton(type: .custom)
        bonusButton.setImage(UIImage(named: "Question"), for: .normal)
        bonusButton.imageView?.contentMode = .scaleAspectFit
        bonusButton.translatesAutoresizingMaskIntoConstraints = false
        bonusButton.addTarget(self, action: #selector(bonusButtonTapped), for: .touchUpInside)
        // в контейнер
        let bonusContainer = UIView()
        bonusContainer.translatesAutoresizingMaskIntoConstraints = false
        bonusContainer.addSubview(bonusButton)
        stackView.addArrangedSubview(bonusContainer)
        // Constraints внутри контейнера
        NSLayoutConstraint.activate([
            bonusButton.centerXAnchor.constraint(equalTo: bonusContainer.centerXAnchor),
            bonusButton.topAnchor.constraint(equalTo: bonusContainer.topAnchor),
            bonusButton.bottomAnchor.constraint(equalTo: bonusContainer.bottomAnchor),
            bonusButton.heightAnchor.constraint(equalToConstant: 50),
            bonusButton.widthAnchor.constraint(equalToConstant: 260)
        ])

        view.addSubview(stackView)
        
        // Close Button
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        
        // Switch Actions
        soundSwitch.addTarget(self, action: #selector(soundSwitchChanged), for: .valueChanged)
        vibrationSwitch.addTarget(self, action: #selector(vibrationSwitchChanged), for: .valueChanged)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Background
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            // Close Button
            closeButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 60),
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupInitialValues() {
        soundSwitch.isOn = SoundManager.shared.soundEnabled
        vibrationSwitch.isOn = SoundManager.shared.vibrationEnabled
    }
    
    private func createSettingRow(label: UILabel, toggle: UISwitch) -> UIStackView {
        let row = UIStackView(arrangedSubviews: [label, toggle])
        row.axis = .horizontal
        row.spacing = 20
        return row
    }
    
     // 
    @objc private func soundSwitchChanged() {
        SoundManager.shared.updateSound(soundSwitch.isOn)
    }
    
    @objc private func vibrationSwitchChanged() {
        SoundManager.shared.updateVibration(vibrationSwitch.isOn)
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func bonusButtonTapped() {
        print("✅ Bonus tapped")

        let vc = NotificationsViewController()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
}
