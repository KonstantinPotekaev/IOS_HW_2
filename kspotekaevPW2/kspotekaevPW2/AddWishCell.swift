import UIKit

final class AddWishCell: UITableViewCell {
    static let reuseId = "AddWishCell"
    
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your wish:"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .darkText
        textView.backgroundColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var addWish: ((String) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.addSubview(instructionLabel)
        contentView.addSubview(textView)
        
        let addButton = UIButton(type: .system)
        addButton.setTitle("Add Wish", for: .normal)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(addWishTapped), for: .touchUpInside)
        contentView.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            instructionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            instructionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            instructionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            textView.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 10),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            textView.heightAnchor.constraint(equalToConstant: 80),
            
            addButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 10),
            addButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            addButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    @objc private func addWishTapped() {
        guard let text = textView.text, !text.isEmpty else { return }
        addWish?(text)
        textView.text = "" // Очищаем поле после добавления желания
    }
}
