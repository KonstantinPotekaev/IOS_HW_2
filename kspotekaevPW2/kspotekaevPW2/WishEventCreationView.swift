import UIKit

protocol WishEventCreationDelegate: AnyObject {
    func didCreateEvent(_ event: WishEventModel)
}

final class WishEventCreationView: UIViewController {
    
    weak var delegate: WishEventCreationDelegate?
    
    // Поля ввода
    private let titleField = UITextField()
    private let descriptionField = UITextField()
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
    }

    private func configureUI() {
        // Конфигурация полей ввода
        titleField.placeholder = "Enter title"
        titleField.borderStyle = .roundedRect
        descriptionField.placeholder = "Enter description"
        descriptionField.borderStyle = .roundedRect
        
        // Конфигурация datePicker
        startDatePicker.datePickerMode = .dateAndTime
        endDatePicker.datePickerMode = .dateAndTime
        
        // Добавляем заголовки
        let titleLabel = UILabel()
        titleLabel.text = "Event Title"
        titleLabel.font = .systemFont(ofSize: 16)
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Event Description"
        descriptionLabel.font = .systemFont(ofSize: 16)
        
        let startDateLabel = UILabel()
        startDateLabel.text = "Start Date and Time"
        startDateLabel.font = .systemFont(ofSize: 16)
        
        let endDateLabel = UILabel()
        endDateLabel.text = "End Date and Time"
        endDateLabel.font = .systemFont(ofSize: 16)
        
        // Создаём кнопку "Добавить"
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Add Event", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 8
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        // Создаём кнопку "Выйти"
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.red, for: .normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        
        // Создаём стек
        let stack = UIStackView(arrangedSubviews: [
            titleLabel, titleField,
            descriptionLabel, descriptionField,
            startDateLabel, startDatePicker,
            endDateLabel, endDatePicker,
            saveButton, cancelButton
        ])
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        // Добавляем стек на экран
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    // Метод для сохранения события
    @objc private func saveTapped() {
        guard let title = titleField.text, !title.isEmpty,
              let description = descriptionField.text, !description.isEmpty else {
            // Вы можете добавить обработку пустого ввода
            print("Fields cannot be empty")
            return
        }
        
        let event = WishEventModel(
            title: title,
            description: description,
            startDate: startDatePicker.date,
            endDate: endDatePicker.date
        )
        
        delegate?.didCreateEvent(event)
        dismiss(animated: true)
    }
    
    // Метод для выхода без добавления события
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
}
