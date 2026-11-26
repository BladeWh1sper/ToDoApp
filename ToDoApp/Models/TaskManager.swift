//
//  TaskManager.swift
//  ToDoApp
//
//  Created by Andrew Belik on 25/11/2026.
//

import Foundation

/// Хранит список задач в памяти и выполняет операции над ним.
final class TaskManager {

    // MARK: - Properties

    /// Все задачи в порядке добавления.
    private(set) var tasks: [TodoTask] = []

    /// Только выполненные задачи.
    var completedTasks: [TodoTask] {
        tasks.filter { $0.isCompleted }
    }

    // MARK: - Editing

    /// Добавляет задачу в конец списка.
    ///
    /// - Parameter task: Задача для добавления.
    func add(_ task: TodoTask) {
        tasks.append(task)
    }

    /// Удаляет задачу с указанным идентификатором.
    ///
    /// Если задачи с таким идентификатором нет, ничего не происходит.
    ///
    /// - Parameter id: Идентификатор задачи.
    func remove(id: UUID) {
        tasks.removeAll { $0.id == id }
    }

    /// Изменяет статус выполнения задачи.
    ///
    /// Если задачи с таким идентификатором нет, ничего не происходит.
    ///
    /// - Parameters:
    ///   - isCompleted: Новый статус: `true` — выполнена, `false` — нет.
    ///   - id: Идентификатор задачи.
    func setCompleted(_ isCompleted: Bool, id: UUID) {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else { return }
        tasks[index].isCompleted = isCompleted
    }

    // MARK: - Filtering and Sorting

    /// Возвращает задачи с указанным приоритетом.
    ///
    /// - Parameter priority: Нужный приоритет.
    /// - Returns: Задачи с этим приоритетом в порядке добавления.
    func tasks(with priority: TaskPriority) -> [TodoTask] {
        tasks.filter { $0.priority == priority }
    }

    /// Сортирует задачи по дате создания.
    ///
    /// - Parameters:
    ///   - list: Задачи для сортировки.
    ///   - newestFirst: `true` — сначала новые, `false` — сначала старые.
    ///     По умолчанию `false`.
    /// - Returns: Отсортированный массив задач.
    func sortedByDate(_ list: [TodoTask], newestFirst: Bool = false) -> [TodoTask] {
        list.sorted { newestFirst ? $0.createdAt > $1.createdAt : $0.createdAt < $1.createdAt }
    }
}
