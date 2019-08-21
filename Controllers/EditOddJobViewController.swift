//
//  EditOddJobViewController.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 21/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit

class EditOddJobViewController: UIViewController {
    
    var viewModel: ViewModel!
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d yyyy, h:mm a"
        return formatter
    }()
    
    // MARK: - Life Cycle
    convenience init(viewModel: ViewModel) {
        self.init()
        self.viewModel = viewModel
        initialize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func initialize() {
        let deleteButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: .deleteButtonPressed)
        navigationItem.leftBarButtonItem = deleteButton
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: .saveButtonPressed)
        navigationItem.rightBarButtonItem = saveButton
        
        view.backgroundColor = .white
    }
    
    // MARK: - Actions
    @objc fileprivate func saveButtonPressed(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func deleteButtonPressed(_ sender: UIBarButtonItem) {
        
        // Uncomment these lines
        //    let alert = UIAlertController(title: "Delete this item?", message: nil, preferredStyle: .alert)
        //    let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        //    let delete = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
        //      self?.viewModel.delete()
        //      _ = self?.navigationController?.popViewController(animated: true)
        //    }
        //
        //    alert.addAction(delete)
        //    alert.addAction(cancel)
        //
        //    navigationController?.present(alert, animated: true, completion: nil)
        
        // Delete this line
        _ = navigationController?.popViewController(animated: true)
    }
}

// MARK: - Selectors
extension Selector {
    fileprivate static let saveButtonPressed = #selector(EditToDoItemViewController.saveButtonPressed(_:))
    fileprivate static let deleteButtonPressed = #selector(EditToDoItemViewController.deleteButtonPressed(_:))
}
