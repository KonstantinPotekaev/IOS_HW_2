import UIKit

extension UIColor {
    var inverted: UIColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return UIColor(red: 1 - red, green: 1 - green, blue: 1 - blue, alpha: alpha)
    }
}

final class WishMakerViewController: UIViewController {
    
    private let sliderRed = CustomSlider(title: "Red", min: 0, max: 1)
    private let sliderGreen = CustomSlider(title: "Green", min: 0, max: 1)
    private let sliderBlue = CustomSlider(title: "Blue", min: 0, max: 1)
    
    private let slidersContainer = UIView()

    private let addWishButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Write Down a Wish", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let toggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Toggle Sliders", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let scheduleWishesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Schedule Wish", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureActionStack()
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
        slidersContainer.backgroundColor = .white
        slidersContainer.layer.cornerRadius = 15
        slidersContainer.layer.shadowColor = UIColor.black.cgColor
        slidersContainer.layer.shadowOpacity = 0.2
        slidersContainer.layer.shadowOffset = CGSize(width: 0, height: 5)
        slidersContainer.layer.shadowRadius = 10
        slidersContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(slidersContainer)
        
        let stack = UIStackView(arrangedSubviews: [sliderRed, sliderGreen, sliderBlue])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        slidersContainer.addSubview(stack)
        
        NSLayoutConstraint.activate([
            slidersContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            slidersContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            slidersContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            slidersContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
        ])
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: slidersContainer.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: slidersContainer.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: slidersContainer.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: slidersContainer.bottomAnchor, constant: -20)
        ])
        
        sliderRed.valueChanged = { [weak self] _ in self?.updateBackgroundColor() }
        sliderGreen.valueChanged = { [weak self] _ in self?.updateBackgroundColor() }
        sliderBlue.valueChanged = { [weak self] _ in self?.updateBackgroundColor() }
    }

    private func updateBackgroundColor() {
        let red = CGFloat(sliderRed.value)
        let green = CGFloat(sliderGreen.value)
        let blue = CGFloat(sliderBlue.value)
        view.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        updateButtonColors()
    }
    
    private func updateButtonColors() {
        let invertedColor = view.backgroundColor?.inverted ?? .white
        addWishButton.setTitleColor(invertedColor, for: .normal)
        scheduleWishesButton.setTitleColor(invertedColor, for: .normal)
    }
    
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
    
    private func configureActionStack() {
        let actionStack = UIStackView(arrangedSubviews: [addWishButton, scheduleWishesButton])
        actionStack.axis = .vertical
        actionStack.spacing = 10
        actionStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(actionStack)
        
        NSLayoutConstraint.activate([
            actionStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            actionStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            actionStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        addWishButton.addTarget(self, action: #selector(addWishButtonPressed), for: .touchUpInside)
        scheduleWishesButton.addTarget(self, action: #selector(scheduleWishesTapped), for: .touchUpInside)
    }

    @objc private func addWishButtonPressed() {
        let wishStoringVC = WishStoringViewController()
        let navController = UINavigationController(rootViewController: wishStoringVC)
        present(navController, animated: true)
    }
    
    @objc private func scheduleWishesTapped() {
        let calendarVC = WishCalendarViewController()
        calendarVC.view.backgroundColor = view.backgroundColor
        navigationController?.pushViewController(calendarVC, animated: true)
    }
}

