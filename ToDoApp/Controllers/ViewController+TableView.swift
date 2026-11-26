//
//  ViewController+TableView.swift
//  ToDoApp
//
//  Created by Andrew Belik on 26/11/2026.
//

import UIKit

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        visibleTasks.count
    }

    /// Настраивает ячейку задачи.
    ///
    /// В ячейке показаны название, описание, приоритет и дата создания.
    /// Выполненная задача отмечается галочкой.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        let task = visibleTasks[indexPath.row]

        var content = UIListContentConfiguration.subtitleCell()
        content.text = task.title
        // Описание показываем отдельной строкой, только если оно есть.
        let details = "\(task.priority.rawValue) • \(task.createdAt.formatted(date: .abbreviated, time: .shortened))"
        content.secondaryText = task.description.isEmpty ? details : "\(task.description)\n\(details)"
        cell.contentConfiguration = content
        cell.accessoryType = task.isCompleted ? .checkmark : .none
        return cell
    }

    /// Переключает статус выполнения задачи по нажатию на строку.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = visibleTasks[indexPath.row]
        taskManager.setCompleted(!task.isCompleted, id: task.id)
        reloadTasks()
    }

    /// Добавляет действие «Удалить» на свайп влево.
    ///
    /// Задача удаляется по идентификатору.
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let task = visibleTasks[indexPath.row]
        let delete = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, done in
            self?.taskManager.remove(id: task.id)
            self?.reloadTasks()
            done(true)
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
}
