import UIKit

final class WishEventCell: UICollectionViewCell {
    static let reuseIdentifier = "WishEventCell"
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()
    private var deleteAction: (() -> Void)?
    private var isSwiping = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, dateLabel])
        stack.axis = .vertical
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
        addSwipeGesture()
    }
    
    func configure(with model: WishEventModel) {
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        dateLabel.text = "\(model.startDate) - \(model.endDate)"
    }
    
    func addSwipeAction(_ action: @escaping () -> Void) {
        deleteAction = action
    }
    
    private func addSwipeGesture() {
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        contentView.addGestureRecognizer(swipeGesture)
    }
    
    @objc private func handleSwipe(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: contentView)
        
        switch gesture.state {
        case .changed:
            if translation.x < 0 {
                isSwiping = true
                contentView.transform = CGAffineTransform(translationX: translation.x, y: 0)
            }
        case .ended:
            if translation.x < -50 {
                isSwiping = false
                deleteAction?()
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.contentView.transform = .identity
                }
            }
        default:
            break
        }
    }
}
