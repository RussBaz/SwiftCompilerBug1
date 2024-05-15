
import Fluent
import Foundation

/// Property wrappers interact poorly with `Sendable` checking, causing a warning for the `@ID` property
/// It is recommended you write your model with sendability checking on and then suppress the warning
/// afterwards with `@unchecked Sendable`.
final class TodoItem: Model, @unchecked Sendable {
    static let schema = "todos"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var value: String

    @OptionalField(key: "done_at")
    var doneAt: Date?

    @Parent(key: "todo_id")
    var todo: Todo

    init() {}

    init(id: UUID? = nil, value: String, done at: Date? = nil) {
        self.id = id
        self.value = value
        doneAt = at
    }
}
