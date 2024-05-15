import Fluent
import Foundation

/// Property wrappers interact poorly with `Sendable` checking, causing a warning for the `@ID` property
/// It is recommended you write your model with sendability checking on and then suppress the warning
/// afterwards with `@unchecked Sendable`.
final class Todo: MyModel, @unchecked Sendable {
    static let schema = "todos"

    @ID(key: .id)
    var id: UUID?

    @OptionalField(key: "title")
    var title: String?

    @OptionalField(key: "done_at")
    var doneAt: Date?

    @Parent(key: "user_id")
    var user: User

    @Children(for: \.$todo)
    var items: [TodoItem]

    init() {}

    init(id: UUID? = nil, title: String) {
        self.id = id
        self.title = title
    }

    func toDTO() -> TodoDTO {
        .init(
            id: id,
            title: $title.value ?? ""
        )
    }
}

extension QueryBuilder where Model == Todo {
    func filterToDos() -> Self {
        join(User.self, on: \User.$id == \Todo.$user.$id)
            .group(.or) { outer in
                outer.filter(Todo.self, \.$title == .null)
                    .filter(Todo.self, \.$doneAt == nil)
            }
            .join(TodoItem.self, on: \TodoItem.$todo.$id == \Todo.$id)
            .filter(Todo.self, \.$title ~~ "another")
    }
}
