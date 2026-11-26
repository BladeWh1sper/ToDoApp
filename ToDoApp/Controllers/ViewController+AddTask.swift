//
//  ViewController+AddTask.swift
//  ToDoApp
//
//  Created by Andrew Belik on 26/11/2026.
//

import UIKit

// MARK: - Adding Tasks

extension ViewController {

    /// Показывает окно добавления новой задачи.
    ///
    /// В окне два поля — название и описание. Кнопки окна задают приоритет:
    /// нажатие на любую из них создаёт задачу и обновляет список.
    ///
    /// - Note: Задача без названия не добавляется.
    func showAddTaskAlert() {
        let alert = UIAlertController(title: "Новая задача", message: "Выберите приоритет", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Название" }
        alert.addTextField { $0.placeholder = "Описание" }

        for priority in TaskPriority.allCases {
            alert.addAction(UIAlertAction(title: priority.rawValue, style: .default) { [weak self, weak alert] _ in
                let title = alert?.textFields?[0].text ?? ""
                let description = alert?.textFields?[1].text ?? ""
                guard !title.isEmpty else { return }
                self?.taskManager.add(TodoTask(title: title, description: description, priority: priority))
                self?.reloadTasks()
            })
        }
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }
}
