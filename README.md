# ToDoApp

Простое iOS-приложение (UIKit) со списком задач.

## Что умеет

У каждой задачи есть название, описание, дата создания, приоритет и статус выполнения.

1. Добавлять задачи — кнопка «Добавить».
2. Удалять задачу по идентификатору — свайп влево по строке.
3. Менять статус — нажатие на задачу ставит или снимает галочку.
4. Показывать все задачи — фильтр «Все».
5. Показывать только завершённые — фильтр «Готово».
6. Показывать задачи одного приоритета — фильтры «Низкий», «Средний», «Высокий».
7. Сортировать по дате создания — кнопка «Сначала старые / Сначала новые».

Задачи хранятся только в памяти, после перезапуска список пустой.

## Структура

```
ToDoApp/
├── Models/
│   ├── TaskPriority.swift              — приоритет задачи
│   ├── TodoTask.swift                  — сама задача
│   └── TaskManager.swift               — добавление, удаление, фильтры, сортировка
└── Controllers/
    ├── ViewController.swift            — экран, фильтр и сортировка
    ├── ViewController+TableView.swift  — таблица: показ, смена статуса, удаление
    └── ViewController+AddTask.swift    — окно добавления задачи
```

Тесты для `TaskManager` лежат в `ToDoAppTests/ToDoAppTests.swift` (Swift Testing).

---

## Вопрос: что произойдёт при выполнении кода?

```swift
struct Employee {
    let name: String?
    let age: Int
    let gender: String
    let salary: Int
    let isActive: String
}
let employees = [
    Employee(name: "Алексей", age: 25, gender: "Мужчина", salary: 150000, isActive: "Да"),
    Employee(name: nil, age: 30, gender: "Женщина", salary: 180000, isActive: "Да"),
    Employee(name: "Мария", age: 22, gender: "Женщина", salary: 90000, isActive: "Нет"),
    Employee(name: "Иван", age: 28, gender: "Мужчина", salary: 170000, isActive: "Да"),
    Employee(name: "Екатерина", age: 35, gender: "Женщина", salary: 210000, isActive: "Нет")
]
func printEmployees() {
    for employee in employees {
        print(employee.name!)
    }
}
printEmployees()
```

### Что будет

Программа напечатает `Алексей`, а потом крашнется.

### Почему

`name` объявлено как `String?`, то есть опционал. У второго сотрудника оно как раз `nil`. Через знак `!` (force unwrap) мы говорим что уверены что там есть значение. Если значения нет, то выдает ошибку и программа падает: 

```
Fatal error: Unexpectedly found nil while unwrapping an Optional value
```

До остальных дело уже не доходит.

###  Как исправить

Не делать `!`, а обрабатывать подрузамевая что у нас имени может и не быть. Например, запасной текст:

```swift
print(employee.name ?? "Без имени")
```

или вообще пропустить такого сотрудника:

```swift
if let name = employee.name {
    print(name)
}
```

### Что ещё можно улучшить

Вообще странно что у сотрудника нет имени, поэтому можно сделать его обязательным  `let name: String`. Тогда проблемы с `nil` вообще не будет. Поменять `isActive` на `Bool`. Так  у нас не будут возникать легкие ошибки по регистру. Поменять `gender` на `enum`. Так мы лочим варианты и нельзя будет придумать другой. Писать числа для повышения readability через нижнее подчеркивание. В функцию передавать список параметром, а не брать как глобалку, проще для тестов.

Исправленный вариант:

```swift
enum Gender {
    case male
    case female
}

struct Employee {
    let name: String
    let age: Int
    let gender: Gender
    let salary: Int
    let isActive: Bool
}

let employees = [
    Employee(name: "Алексей", age: 25, gender: .male, salary: 150_000, isActive: true),
    Employee(name: "Ольга", age: 30, gender: .female, salary: 180_000, isActive: true),
    Employee(name: "Мария", age: 22, gender: .female, salary: 90_000, isActive: false),
    Employee(name: "Иван", age: 28, gender: .male, salary: 170_000, isActive: true),
    Employee(name: "Екатерина", age: 35, gender: .female, salary: 210_000, isActive: false)
]

func printEmployees(_ employees: [Employee]) {
    for employee in employees {
        print(employee.name)
    }
}

printEmployees(employees)
```

Если имени может не быть, надо оставить `String?`, и выводить его сказано выше.
