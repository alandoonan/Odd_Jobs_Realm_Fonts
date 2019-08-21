//
//  OddJobListView.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 21/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import Foundation

extension ToDoListViewController {
    
    class ViewModel {
        
        private var toDos: [ToDo]
        private lazy var dateFormatter: DateFormatter = {
            let fmtr = DateFormatter()
            fmtr.dateFormat = "EEEE, MMM d"
            return fmtr
        }()
        
        var numberOfToDos: Int {
            return toDos.count
        }
        
        private func toDo(at index: Int) -> ToDo {
            return toDos[index]
        }
        
        func title(at index: Int) -> String {
            return toDo(at: index).title ?? ""
        }
        
        func dueDateText(at index: Int) -> String {
            let date = toDo(at: index).dueDate
            return dateFormatter.string(from: date)
        }
        
        func editViewModel(at index: Int) -> EditToDoItemViewController.ViewModel {
            let toDo = self.toDo(at: index)
            let editViewModel = EditToDoItemViewController.ViewModel(toDo: toDo)
            return editViewModel
        }
        
        func addViewModel() -> EditToDoItemViewController.ViewModel {
            let toDo = ToDo()
            toDos.append(toDo)
            let addViewModel = EditToDoItemViewController.ViewModel(toDo: toDo)
            return addViewModel
        }
        
        @objc private func removeToDo(_ notification: Notification) {
            guard let userInfo = notification.userInfo,
                let toDo = userInfo[Notification.Name.deleteToDoNotification] as? ToDo,
                let index = toDos.firstIndex(of: toDo) else {
                    return
            }
            toDos.remove(at: index)
        }
        
        // MARK: Life Cycle
        init(toDos: [ToDo] = []) {
            self.toDos = toDos
            
            NotificationCenter.default.addObserver(self, selector: #selector(removeToDo(_:)), name: .deleteToDoNotification, object: nil)
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
    }
}
