import UIKit

protocol WishEventCreationDelegate: AnyObject {
    func didCreateEvent(_ event: WishEventModel)
}

final class WishEventCreationView: UIViewController {
    
    weak var delegate: WishEventCreationDelegate?
    var preselectedWish: String?
    
    private let titleField = UITextField()
    private let descriptionField = UITextField()
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    private let selectWishButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        if let preselectedWish = preselectedWish {
            titleField.text = preselectedWish
        }
    }

    private func configureUI() {
        titleField.placeholder = "Enter title"
        titleField.borderStyle = .roundedRect
        descriptionField.placeholder = "Enter description"
        descriptionField.borderStyle = .roundedRect
        
        startDatePicker.datePickerMode = .dateAndTime
        endDatePicker.datePickerMode = .dateAndTime
        
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
        
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Add Event", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 8
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.red, for: .normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        
        selectWishButton.setTitle("Select Existing Wish", for: .normal)
        selectWishButton.setTitleColor(.systemBlue, for: .normal)
        selectWishButton.addTarget(self, action: #selector(selectWishTapped), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [
            titleLabel, titleField,
            selectWishButton,
            descriptionLabel, descriptionField,
            startDateLabel, startDatePicker,
            endDateLabel, endDatePicker,
            saveButton, cancelButton
        ])
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    @objc private func saveTapped() {
        var event = WishEventModel(
            title: titleField.text ?? "No Title",
            description: descriptionField.text ?? "",
            startDate: startDatePicker.date,
            endDate: endDatePicker.date,
            eventIdentifier: nil
        )

        let calendarEvent = CalendarEventModel(
            title: event.title,
            startDate: event.startDate,
            endDate: event.endDate,
            notes: event.description
        )

        let calendarManager = CalendarManager()
        calendarManager.addEvent(event: calendarEvent) { identifier in
            guard let identifier = identifier else {
                print("Failed to save event in calendar")
                return
            }
            event.eventIdentifier = identifier
            DispatchQueue.main.async {
                        self.delegate?.didCreateEvent(event)
                        self.dismiss(animated: true)
                    }
        }
    }


    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func selectWishTapped() {
        let savedWishes = loadSavedWishes()
        guard !savedWishes.isEmpty else {
            let alert = UIAlertController(
                title: "No Wishes",
                message: "You need to write down at least one wish before selecting.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        let wishSelectionVC = WishSelectionViewController(wishes: savedWishes)
        wishSelectionVC.delegate = self
        let navController = UINavigationController(rootViewController: wishSelectionVC)
        present(navController, animated: true)
    }

    private func loadSavedWishes() -> [String] {
        let defaults = UserDefaults.standard
        return defaults.array(forKey: "savedWishes") as? [String] ?? []
    }
}

// MARK: - WishSelectionDelegate
extension WishEventCreationView: WishSelectionDelegate {
    func didSelectWish(_ wish: String) {
        titleField.text = wish
    }
}
