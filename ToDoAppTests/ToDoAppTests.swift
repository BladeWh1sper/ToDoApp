//
//  ToDoAppTests.swift
//  ToDoAppTests
//
//  Created by Andrew Belik on 25/11/2026.
//

import Foundation
import Testing
@testable import ToDoApp

struct TaskManagerTests {

    @Test func addTask() {
        let manager = TaskManager()
        let task = TodoTask(title: "Купить хлеб", description: "Белый", priority: .high)
        manager.add(task)

        #expect(manager.tasks == [task])
    }

    @Test func removeTaskById() {
        let manager = TaskManager()
        let first = TodoTask(title: "1", description: "", priority: .low)
        let second = TodoTask(title: "2", description: "", priority: .low)
        manager.add(first)
        manager.add(second)

        manager.remove(id: first.id)

        #expect(manager.tasks == [second])
    }

    @Test func changeStatusAndGetCompleted() {
        let manager = TaskManager()
        let done = TodoTask(title: "Готово", description: "", priority: .low)
        manager.add(done)
        manager.add(TodoTask(title: "Не готово", description: "", priority: .low))

        manager.setCompleted(true, id: done.id)

        #expect(manager.completedTasks.map(\.id) == [done.id])
    }

    @Test func tasksWithPriority() {
        let manager = TaskManager()
        let high = TodoTask(title: "Срочно", description: "", priority: .high)
        manager.add(high)
        manager.add(TodoTask(title: "Потом", description: "", priority: .low))

        #expect(manager.tasks(with: .high) == [high])
        #expect(manager.tasks(with: .medium).isEmpty)
    }

    @Test func sortByDate() {
        let manager = TaskManager()
        let old = TodoTask(title: "Старая", description: "", createdAt: Date(timeIntervalSince1970: 0), priority: .low)
        let new = TodoTask(title: "Новая", description: "", createdAt: Date(timeIntervalSince1970: 100), priority: .low)

        #expect(manager.sortedByDate([new, old]) == [old, new])
        #expect(manager.sortedByDate([old, new], newestFirst: true) == [new, old])
    }
}
