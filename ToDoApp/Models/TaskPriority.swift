//
//  TaskPriority.swift
//  ToDoApp
//
//  Created by Andrew Belik on 26/11/2026.
//

import Foundation

/// Приоритет задачи.
///
/// Исходное значение (`rawValue`) — название приоритета для показа пользователю.
nonisolated enum TaskPriority: String, CaseIterable {
    /// Задача может подождать.
    case low = "Низкий"
    /// Обычная задача.
    case medium = "Средний"
    /// Задачу нужно сделать в первую очередь.
    case high = "Высокий"
}
