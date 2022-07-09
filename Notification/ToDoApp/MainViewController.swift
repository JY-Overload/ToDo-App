//
//  ViewController.swift
//  ToDoApp
//
//  Created by Daniel on 2021/1/27.
//

import UIKit
import RealmSwift
import NotificationCenter



// remind function: create notification
let notifCenter = UNUserNotificationCenter.current()

func createNotification(taskTitle: String, dueDate: Date, remindDate: Date) -> String  {
    
    
    // 2. create the notification content
    let content = UNMutableNotificationContent()
    content.title = "Upcoming Task: \(taskTitle)"
    content.body = "Your task \"" + taskTitle + "\" is due "
    
    // 3. create notification trigger
    let currentDate = remindDate
    
    let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentDate)

    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    
    // 4. create a request
    let uuidString = UUID().uuidString
    let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
    
    // 5. register with notification center
    notifCenter.add(request) { (error) in
        // Potential todo: check the error parameter and handle any errors
        
    }
    
    return uuidString
}

// create task object class
class ToDoListItem: Object {
    @objc dynamic var item: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var remindDate: Date = Date()
    @objc dynamic var colorName: String = ""
    @objc dynamic var checkStatus: Bool = false
    @objc dynamic var mark: Bool = false
    @objc dynamic var uuid: String = ""
}

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
      
    @IBOutlet var taskTable: UITableView!
    
    public var taskList = [ToDoListItem]()
    let realm = try! Realm()
    var taskIndex: Int = 0
    
    // read date to correct string format
    func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        return dateFormatter.string(from: date)
    }
    
    // create task table (table view)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
        }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! taskCell
       
        // show task title and information
        cell.taskTitle?.text = taskList.reversed()[indexPath.row].item
        cell.taskTitle.textColor = stringToColor(colorName: taskList.reversed()[indexPath.row].colorName)
        cell.taskDueTime?.text = dateToString(date: taskList.reversed()[indexPath.row].date)
        cell.taskDueTime.textColor = stringToColor(colorName: taskList.reversed()[indexPath.row].colorName)
        
        // show check status with correct image
        if taskList.reversed()[indexPath.row].checkStatus == false {
            cell.checkBox.setImage(UIImage(named: "uncheck.png"), for: .normal)
        } else {
            cell.checkBox.setImage(UIImage(named: "check.png"), for: .normal)
        }
        if let checkBox = cell.checkBox {
            checkBox.tag = indexPath.row
            checkBox.addTarget(self, action: #selector(tapCheck(_ :)), for: .touchUpInside)
            }
        // show mark as important image
        if taskList.reversed()[indexPath.row].mark == false {
            cell.markImage.image = nil
        } else {
            cell.markImage?.image = UIImage(named: "star.png")
        }
        return cell
    }
    
    
    // check or uncheck to show button image
    @objc func tapCheck (_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true {
        sender.setImage(UIImage(named: "check.png"), for: .normal)
        notifCenter.removePendingNotificationRequests(withIdentifiers: [taskList.reversed()[sender.tag].uuid])
        realm.beginWrite()
        taskList.reversed()[sender.tag].checkStatus = true
        try! realm.commitWrite()
        } else {
            sender.setImage(UIImage(named: "uncheck.png"), for: .normal)
            realm.beginWrite()
            taskList.reversed()[sender.tag].checkStatus = false
            try! realm.commitWrite()
        }
        
    }
    
    // select task to edit
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let task = taskList.reversed()[indexPath.row]
        
        guard let vc = storyboard?.instantiateViewController(identifier: "edit") as? EditViewController else {
            return
        }
        vc.task = task 
        vc.deletionHandler = { [weak self] in
            self?.refresh()
        }
        vc.title = task.item
        navigationController?.pushViewController(vc, animated: true)
    }
    // adjust cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notifCenter.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        }
        taskList = realm.objects(ToDoListItem.self).map({$0})
       
    }
   
   
    
   // refresh task table to show change on create and edit view
   func refresh() {
        taskList = realm.objects(ToDoListItem.self).map({ $0 })
        taskTable.reloadData()
    }
    
    // color picker
    func stringToColor (colorName:String) -> UIColor {
        
        var color = UIColor.black
        
        switch colorName {
        case "Black":
            color = .black
        case "Red":
            color = .red
        case "Orange":
            color = .orange
        case "Green":
            color = .green
        case "Blue":
            color = .blue
        default:
            color = .black
        }
        return color
    }
    

    // click "+" to active add task func
    @IBAction func addTask(_ sender: Any) {
        
        guard let VC = storyboard?.instantiateViewController(identifier: "create") as? CreateViewController else {
            return
        }
        
        VC.refreshFunc = { [weak self] in
            self?.refresh()
        }
        navigationController?.pushViewController(VC, animated: true)
        
    }
    
   
        
    }



    



   
 

