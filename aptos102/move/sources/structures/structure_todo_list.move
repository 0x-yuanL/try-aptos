module todo_list::structs {
    use aptos_framework::event;
    use std::string::String;
    use aptos_std::table::Table;

    struct Task has store, drop, copy {
        id: u64,
        address: address,
        content: String,
        done: bool,
    }

    struct TodoList has key {
        tasks: Table<u64, Task>,
        task_count: u64,
        set_task_event: event::EventHandle<Task>
    }
}