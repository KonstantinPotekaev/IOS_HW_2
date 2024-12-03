import UIKit

final class WishCalendarViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private var events: [WishEventModel] = [] {
        didSet {
            saveEvents() // Сохраняем события при изменении массива
        }
    }
    
    private let defaults = UserDefaults.standard
    private let eventsKey = "SavedEvents"

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureNavigationBar()
        loadEvents() // Загружаем события при загрузке экрана
    }

    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WishEventCell.self, forCellWithReuseIdentifier: WishEventCell.reuseIdentifier)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func configureNavigationBar() {
        title = "Wish Calendar"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addEventTapped)
        )
    }
    
    // MARK: - UserDefaults Management
    private func saveEvents() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(events) {
            defaults.set(encoded, forKey: eventsKey)
        }
    }
    
    private func loadEvents() {
        guard let savedData = defaults.data(forKey: eventsKey) else { return }
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode([WishEventModel].self, from: savedData) {
            events = decoded
        }
    }
    
    // MARK: - Delete Event
    private func deleteEvent(at indexPath: IndexPath) {
        // Убедимся, что индекс существует в массиве
        guard indexPath.item < events.count else {
            print("Index out of range")
            return
        }

        // Сохраняем идентификатор события перед удалением из массива
        let event = events[indexPath.item]
        let identifierToDelete = event.eventIdentifier
        
        // Удаляем элемент из массива и обновляем коллекцию
        collectionView.performBatchUpdates({
            events.remove(at: indexPath.item)
            collectionView.deleteItems(at: [indexPath])
        }, completion: nil)

        // Выполняем удаление из календаря после синхронизации массива и коллекции
        if let identifier = identifierToDelete {
            let calendarManager = CalendarManager()
            calendarManager.requestAccess { granted in
                guard granted else {
                    print("Access to calendar denied")
                    return
                }
                calendarManager.deleteEvent(with: identifier) { success in
                    if success {
                        print("Event removed from calendar")
                    } else {
                        print("Failed to remove event from calendar")
                    }
                }
            }
        }
    }


    
    var preselectedWish: String?
    @objc private func addEventTapped() {
           let eventVC = WishEventCreationView()
           eventVC.preselectedWish = preselectedWish
           eventVC.delegate = self
           present(eventVC, animated: true)
       }
}

// MARK: - WishEventCreationDelegate
extension WishCalendarViewController: WishEventCreationDelegate {
    func didCreateEvent(_ event: WishEventModel) {
        events.append(event)
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension WishCalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WishEventCell.reuseIdentifier, for: indexPath) as! WishEventCell
        cell.configure(with: events[indexPath.item])
        
        cell.addSwipeAction { [weak self] in
            guard let self = self else { return }
            self.deleteEvent(at: indexPath)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WishCalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 20, height: 100)
    }
}
