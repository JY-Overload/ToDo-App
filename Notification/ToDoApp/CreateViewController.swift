//
//  CreateNewTask.swift
//  ToDoApp
//
//  Created by Daniel on 2021/1/27.
//

import UIKit
import RealmSwift
import UserNotifications

class CreateViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
   
    @IBOutlet weak var createButton: UIBarButtonItem!
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var taskDueDate: UIDatePicker!
    @IBOutlet weak var taskRemindDate: UIDatePicker!
    @IBOutlet weak var markSwitch: UISwitch!
    @IBOutlet weak var taskColor: UIPickerView!
 
    
    public var refreshFunc: (() -> Void)?
    
    
    let realm = try! Realm()
    // set color picker view
    let colors = ["Black","Red","Orange","Green","Blue"]
    var colorName = ""
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colors.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        colorName = colors[row]
        return colors[row]
    }
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        taskTitle.becomeFirstResponder()
        taskTitle.delegate = self
        taskColor.delegate = self
        taskColor.dataSource = self
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
   
    
    // tap create button activate save task func
    @IBAction func saveTask() {
       
        if taskTitle.text != nil {
        
        realm.beginWrite()
        let newItem = ToDoListItem()
        newItem.date = taskDueDate.date
        newItem.item = taskTitle.text!
        newItem.remindDate = taskRemindDate.date
        newItem.colorName = colorName
        newItem.mark = markSwitch.isOn
        newItem.uuid = createNotification(taskTitle: newItem.item, dueDate: newItem.date, remindDate: newItem.remindDate)
        print("add noti \(newItem.uuid)")
        realm.add(newItem)
        try! realm.commitWrite()
        
        
        refreshFunc?()
        navigationController?.popViewController(animated: true)
        } else {
            print("Add")
        }
        
        
        
    }
}
 
