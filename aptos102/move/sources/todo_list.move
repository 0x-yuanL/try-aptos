module todo_list::main {
    use aptos_framework::event;
    use aptos_framework::account;
    use aptos_std::table::{Self, Table};
    use std::string::String;
    use std::signer;

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

    /*
    ** &signer - The signer argument is injected by the Move VM as the address who signed that transaction.
    */
    public entry fun create_list(account: &signer) {
        let todo_list = TodoList {
            tasks: table::new(),
            task_count: 0,
            set_task_event: account::new_event_handle<Task>(account),
        };

        move_to(account, todo_list);
    }

    public entry fun add_task(account: &signer, content: String) acquires TodoList {
        let signer_address = signer::address_of(account);
        let todo_list = borrow_global_mut<TodoList>(signer_address);
        let task_count = todo_list.task_count + 1;
        let new_task = Task {
            id: task_count,
            address: signer_address,
            content,
            done: false,
        };

        table::upsert(&mut todo_list.tasks, task_count, new_task);
        todo_list.task_count = task_count;
        event::emit_event<Task>(&mut borrow_global_mut<TodoList>(signer_address).set_task_event, new_task);
    }

    public entry fun complete_task(account: &signer, task_id: u64) acquires TodoList {
        let signer_address = signer::address_of(account);
        let todo_list = borrow_global_mut<TodoList>(signer_address);
        let task_record = table::borrow_mut(&mut todo_list.tasks, task_id);
        task_record.done = true;
    }
}