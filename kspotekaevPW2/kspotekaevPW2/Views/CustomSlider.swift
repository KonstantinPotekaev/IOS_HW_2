import UIKit

final class CustomSlider: UIView {
    var valueChanged: ((Double) -> Void)?
    private let slider = UISlider()
    private let titleView = UILabel()

    // Добавляем свойство для получения значения слайдера
    var value: Double {
        return Double(slider.value)
    }

    init(title: String, min: Double, max: Double) {
        super.init(frame: .zero)
        titleView.text = title
        slider.minimumValue = Float(min)
        slider.maximumValue = Float(max)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false

        // Настраиваем titleView
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.font = UIFont.systemFont(ofSize: 16)
        addSubview(titleView)

        // Настраиваем slider
        slider.translatesAutoresizingMaskIntoConstraints = false
        addSubview(slider)

        // Устанавливаем констрейнты для titleView и slider
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: topAnchor),
            titleView.centerXAnchor.constraint(equalTo: centerXAnchor),

            slider.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 10),
            slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            slider.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @objc private func sliderValueChanged() {
        valueChanged?(Double(slider.value))
    }
}
