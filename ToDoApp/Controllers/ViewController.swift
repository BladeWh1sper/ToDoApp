//
//  ViewController.swift
//  ToDoApp
//
//  Created by Andrew Belik on 25/11/2026.
//

import UIKit

/// Главный экран: список задач с фильтром, сортировкой и добавлением.
class ViewController: UIViewController {

    /// Какие задачи показывать в списке.
    enum Filter {
        /// Все задачи.
        case all
        /// Только выполненные задачи.
        case completed
        /// Только задачи с указанным приоритетом.
        case priority(TaskPriority)
    }

    // MARK: - Properties

    /// Хранилище задач.
    let taskManager = TaskManager()
    /// Таблица со списком задач.
    let tableView = UITableView(frame: .zero, style: .insetGrouped)

    /// Текущий фильтр списка.
    var filter: Filter = .all
    /// Порядок сортировки: `true` — сначала новые, `false` — сначала старые.
    var newestFirst = false
    /// Задачи, которые сейчас показаны в таблице (после фильтра и сортировки).
    var visibleTasks: [TodoTask] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground

        title = "Задачи"
        navigationItem.leftBarButtonItem = makeSortItem()
        let addItem = UIBarButtonItem(systemItem: .add, primaryAction: UIAction { [weak self] _ in
            self?.showAddTaskAlert()
        })
        addItem.accessibilityLabel = "Добавить задачу"
        navigationItem.rightBarButtonItem = addItem

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")

        let stack = UIStackView(arrangedSubviews: [makeFilterButton(), tableView])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        reloadTasks()
    }

    // MARK: - Data

    /// Применяет фильтр и сортировку, затем обновляет таблицу.
    ///
    /// Вызывайте после любого изменения задач, фильтра или порядка сортировки.
    func reloadTasks() {
        let filtered: [TodoTask]
        switch filter {
        case .all: filtered = taskManager.tasks
        case .completed: filtered = taskManager.completedTasks
        case .priority(let priority): filtered = taskManager.tasks(with: priority)
        }
        visibleTasks = taskManager.sortedByDate(filtered, newestFirst: newestFirst)
        tableView.reloadData()
    }

    // MARK: - Private Methods

    /// Создаёт кнопку сортировки для навигационной панели.
    ///
    /// Кнопка показана символом, по нажатию открывается меню с порядком сортировки.
    /// Текущий вариант отмечен галочкой.
    ///
    /// - Returns: Кнопка с выбранным вариантом «Сначала старые».
    private func makeSortItem() -> UIBarButtonItem {
        let options: [(String, Bool)] = [("Сначала старые", false), ("Сначала новые", true)]

        let actions = options.map { title, newestFirst in
            UIAction(title: title, state: newestFirst == self.newestFirst ? .on : .off) { [weak self] _ in
                self?.newestFirst = newestFirst
                self?.reloadTasks()
            }
        }

        let menu = UIMenu(title: "Сортировка по дате", options: .singleSelection, children: actions)
        let item = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), menu: menu)
        item.accessibilityLabel = "Сортировка"
        return item
    }

    /// Создаёт кнопку выбора фильтра со всплывающим меню.
    ///
    /// Пункты меню: «Все», «Готово» и по одному на каждый приоритет.
    /// Выбранный пункт отмечается галочкой и показывается на кнопке.
    ///
    /// - Returns: Кнопка с выбранным пунктом «Все».
    private func makeFilterButton() -> UIButton {
        let filters: [(String, Filter)] = [("Все", .all), ("Готово", .completed)]
            + TaskPriority.allCases.map { ($0.rawValue, .priority($0)) }

        let actions = filters.map { title, filter in
            UIAction(title: title) { [weak self] _ in
                self?.filter = filter
                self?.reloadTasks()
            }
        }
        actions.first?.state = .on

        let button = UIButton(configuration: .gray())
        button.menu = UIMenu(title: "Показать", children: actions)
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        return button
    }
}
