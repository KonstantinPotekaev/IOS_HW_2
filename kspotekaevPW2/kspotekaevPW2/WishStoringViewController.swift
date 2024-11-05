import UIKit

final class WishStoringViewController: UIViewController {

    private let tableView = UITableView()
    private var wishArray: [String] = []
    private let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        loadWishes()
        configureTableView()
        configureCloseButton()
    }

    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(WrittenWishCell.self, forCellReuseIdentifier: WrittenWishCell.reuseId)
        tableView.register(AddWishCell.self, forCellReuseIdentifier: AddWishCell.reuseId)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadWishes() {
        wishArray = defaults.array(forKey: "savedWishes") as? [String] ?? []
    }

    private func saveWishes() {
        defaults.set(wishArray, forKey: "savedWishes")
    }
    
    private func configureCloseButton() {
            // Настраиваем кнопку "Close" в верхней панели
            let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeButtonTapped))
            navigationItem.rightBarButtonItem = closeButton
        }

        @objc private func closeButtonTapped() {
            dismiss(animated: true)
        }
}

// MARK: - UITableViewDataSource и UITableViewDelegate

extension WishStoringViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : wishArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddWishCell.reuseId, for: indexPath) as! AddWishCell
            cell.addWish = { [weak self] wish in
                self?.wishArray.append(wish)
                self?.saveWishes()
                self?.tableView.reloadData()
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: WrittenWishCell.reuseId, for: indexPath) as! WrittenWishCell
            cell.configure(with: wishArray[indexPath.row])
            return cell
        }
    }

    // Разрешаем редактировать строки
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            wishArray.remove(at: indexPath.row)
            saveWishes()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Обработка нажатия на ячейку для редактирования желания
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        let currentWish = wishArray[indexPath.row]
        
        let alert = UIAlertController(title: "Edit Wish", message: "Modify your wish below:", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = currentWish
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self, weak alert] _ in
            guard let newText = alert?.textFields?.first?.text, !newText.isEmpty else { return }
            self?.wishArray[indexPath.row] = newText
            self?.saveWishes()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}
