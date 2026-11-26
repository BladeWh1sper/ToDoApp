//
//  TodoTask.swift
//  ToDoApp
//
//  Created by Andrew Belik on 25/11/2026.
//

import Foundation

/// Задача из списка дел.
///
/// Тип назван `TodoTask`, чтобы не конфликтовать с `Task` из Swift Concurrency.
///
/// - Note: Тип помечен `nonisolated`: это просто данные, они не привязаны
///   к главному потоку, поэтому задачи можно сравнивать в любом контексте,
///   например внутри `#expect` в тестах.
nonisolated struct TodoTask: Identifiable, Equatable {
    /// Уникальный идентификатор, создаётся автоматически.
    let id = UUID()
    /// Название задачи.
    var title: String
    /// Подробное описание задачи. Может быть пустым.
    var description: String
    /// Дата создания. По умолчанию — момент создания задачи.
    var createdAt = Date()
    /// Приоритет задачи.
    var priority: TaskPriority
    /// Выполнена ли задача. По умолчанию — `false`.
    var isCompleted = false
}
