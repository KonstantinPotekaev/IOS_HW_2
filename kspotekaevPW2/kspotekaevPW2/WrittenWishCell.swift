import UIKit

final class WrittenWishCell: UITableViewCell {
    static let reuseId = "WrittenWishCell"

    private let wishLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        wishLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(wishLabel)
        
        NSLayoutConstraint.activate([
            wishLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            wishLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            wishLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            wishLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    func configure(with wish: String) {
        wishLabel.text = wish
    }
}
