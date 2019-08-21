//
//  EditOddJobView.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 21/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit

extension EditOddJobViewController {
    
    class ViewModel {
        
        private let toDo: OddJobTask
        
        var title: String? {
            get {
                return toDo.title
            }
            set {
                toDo.title = newValue
            }
        }
        
        var dueDate: Date {
            get {
                return toDo.dueDate
            }
            set {
                toDo.dueDate = newValue
            }
        }
        
        let reminderOptions: [String] = [OddJobTask.Reminder.none.rawValue,
                                         OddJobTask.Reminder.halfHour.rawValue,
                                         OddJobTask.Reminder.oneHour.rawValue,
                                         OddJobTask.Reminder.oneDay.rawValue,
                                         OddJobTask.Reminder.oneWeek.rawValue]
        var reminder: String? {
            get {
                return toDo.reminder.rawValue
            }
            set {
                if let value = newValue {
                    toDo.reminder = ToDo.Reminder(rawValue: value)!
                }
            }
        }
        
        var image: UIImage? {
            get {
                if let data = toDo.image {
                    return UIImage(data: data)
                }
                return nil
            }
            set {
                if let img = newValue {
                    toDo.image = img.pngData()
                } else {
                    toDo.image = nil
                }
            }
        }
        
        let priorityOptions: [String] = [ToDo.Priority.low.rawValue,
                                         ToDo.Priority.medium.rawValue,
                                         ToDo.Priority.high.rawValue]
        
        var priority: String {
            get {
                return toDo.priority.rawValue
            }
            set {
                toDo.priority = ToDo.Priority(rawValue: newValue)!
            }
        }
        
        var categoryOptions: [String] = [ToDo.Category.home.rawValue,
                                         ToDo.Category.work.rawValue,
                                         ToDo.Category.personal.rawValue,
                                         ToDo.Category.play.rawValue,
                                         ToDo.Category.health.rawValue ]
        var category: String? {
            get {
                return toDo.category?.rawValue
            }
            set {
                if let value = newValue {
                    toDo.category = ToDo.Category(rawValue: value)!
                }
            }
        }
        
        let repeatOptions: [String] = [ToDo.RepeatFrequency.never.rawValue,
                                       ToDo.RepeatFrequency.daily.rawValue,
                                       ToDo.RepeatFrequency.weekly.rawValue,
                                       ToDo.RepeatFrequency.monthly.rawValue,
                                       ToDo.RepeatFrequency.annually.rawValue]
        
        var repeatFrequency: String {
            get {
                return toDo.repeats.rawValue
            }
            set {
                toDo.repeats = ToDo.RepeatFrequency(rawValue: newValue)!
            }
        }
        
        // MARK: - Life Cycle
        
        init(toDo: ToDo) {
            self.toDo = toDo
        }
        
        // MARK: - Actions
        
        func delete() {
            NotificationCenter.default.post(name: .deleteToDoNotification, object: nil, userInfo: [ Notification.Name.deleteToDoNotification : toDo ])
        }
    }
}

extension Notification.Name {
    static let deleteToDoNotification = Notification.Name("delete todo")
}
