import UIKit

final class WishMakerViewController: UIViewController {
    
    private let sliderRed = CustomSlider(title: "Red", min: 0, max: 1)
    private let sliderGreen = CustomSlider(title: "Green", min: 0, max: 1)
    private let sliderBlue = CustomSlider(title: "Blue", min: 0, max: 1)
    
    private let slidersContainer = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemPink
        configureTitle()
        configureDescription()
        configureSlidersContainer()
        configureToggleButton()
    }

    private func configureTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "WishMaker"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30)
        ])
    }

    private func configureDescription() {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Make your wishes come true!"
        descriptionLabel.font = UIFont.systemFont(ofSize: 18)
        descriptionLabel.textColor = .lightGray
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70)
        ])
    }

    private func configureSlidersContainer() {
        // Настройка контейнера для слайдеров
        slidersContainer.backgroundColor = .white
        slidersContainer.layer.cornerRadius = 15
        slidersContainer.layer.shadowColor = UIColor.black.cgColor
        slidersContainer.layer.shadowOpacity = 0.2
        slidersContainer.layer.shadowOffset = CGSize(width: 0, height: 5)
        slidersContainer.layer.shadowRadius = 10
        slidersContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(slidersContainer)
        
        // Добавляем стек в контейнер
        let stack = UIStackView(arrangedSubviews: [sliderRed, sliderGreen, sliderBlue])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        slidersContainer.addSubview(stack)
        
        // Констрейнты для контейнера, чтобы он располагался внизу экрана
        NSLayoutConstraint.activate([
            slidersContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            slidersContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            slidersContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            slidersContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
        
        // Констрейнты для стека внутри контейнера, чтобы адаптировать высоту контейнера
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: slidersContainer.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: slidersContainer.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: slidersContainer.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: slidersContainer.bottomAnchor, constant: -20)
        ])
        
        // Установка действия для изменения цвета
        sliderRed.valueChanged = { [weak self] _ in self?.updateBackgroundColor() }
        sliderGreen.valueChanged = { [weak self] _ in self?.updateBackgroundColor() }
        sliderBlue.valueChanged = { [weak self] _ in self?.updateBackgroundColor() }
    }

    private func updateBackgroundColor() {
        let red = CGFloat(sliderRed.value)
        let green = CGFloat(sliderGreen.value)
        let blue = CGFloat(sliderBlue.value)
        view.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    private let toggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Toggle Sliders", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func configureToggleButton() {
        view.addSubview(toggleButton)
        toggleButton.addTarget(self, action: #selector(toggleSlidersVisibility), for: .touchUpInside)

        NSLayoutConstraint.activate([
            toggleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toggleButton.bottomAnchor.constraint(equalTo: slidersContainer.topAnchor, constant: -20)
        ])
    }

    @objc private func toggleSlidersVisibility() {
        slidersContainer.isHidden.toggle()
    }
}
