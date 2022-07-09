//
//  EditTask.swift
//  ToDoApp
//
//  Created by Daniel on 2021/1/27.
//

import UIKit
import Realm
import RealmSwift

class EditViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var editTitle: UITextField!
    @IBOutlet weak var editDueDate: UIDatePicker!
    @IBOutlet weak var editRemindDate: UIDatePicker!
    @IBOutlet weak var editColor: UIPickerView! 
    @IBOutlet weak var editSwitch: UISwitch!
    @IBOutlet weak var saveButton: UIButton!
    
    var task: ToDoListItem?
    var deletionHandler: (() -> Void)?
    
    let realm = try! Realm()
    
    let colors = ["Black","Red","Orange","Green","Blue"]
    var newColor = ""
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        newColor = colors[row]
        return colors[row]
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editTitle.becomeFirstResponder()
        editTitle.delegate = self
        editColor.delegate = self
        editColor.dataSource = self
        // save button shape
        saveButton.layer.cornerRadius = 5
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = UIColor.blue.cgColor
        editTitle.text = self.task?.item
        editSwitch.isOn = self.task!.mark
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    @IBAction func tapDelete(_ sender: Any) {
        if let tapTask = self.task {
            // remove task notification
            notifCenter.removePendingNotificationRequests(withIdentifiers: [tapTask.uuid])
            print("remove noti \(tapTask.uuid)")
            //remove task in task list and task table view
            realm.beginWrite()
            realm.delete(tapTask)
            try! realm.commitWrite()
            
            deletionHandler?()
            navigationController?.popToRootViewController(animated: true)
        } else {
            return
        }
    }
    
    
    
    
    
    @IBAction func saveChange(_ sender: Any) {
        if let tapTask = self.task {
            // remove old task notification
            notifCenter.removePendingNotificationRequests(withIdentifiers: [tapTask.uuid])
            print("remove noti \(tapTask.uuid)")
            // save the changes on the task and create new notification
            realm.beginWrite()
            
            tapTask.item = editTitle.text ?? "NO TITLE"
            tapTask.date = editDueDate.date
            tapTask.remindDate = editRemindDate.date
            tapTask.colorName = newColor
            tapTask.mark = editSwitch.isOn
            tapTask.uuid = createNotification(taskTitle: tapTask.item, dueDate: tapTask.date, remindDate: tapTask.remindDate)
            print("add noti \(tapTask.uuid)")
            try! realm.commitWrite()
            
            
            
            deletionHandler?()
            
            navigationController?.popToRootViewController(animated: true)
            
        
        
        
        } else {
            return
        }
        
        
    }
}
