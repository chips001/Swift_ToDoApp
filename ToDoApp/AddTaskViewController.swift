//
//  AddTaskViewController.swift
//  ToDoApp
//
//  Created by 一木 英希 on 2017/11/05.
//  Copyright © 2017年 一木 英希. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {

    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var categorySegmentControl: UISegmentedControl!
    var taskCategory = "ToDo"
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let task = task{
            taskTextField.text = task.name
            taskCategory = task.category!
            
            switch task.category! {
            case "ToDo" :
                categorySegmentControl.selectedSegmentIndex = 0
            case "Shopping" :
                categorySegmentControl.selectedSegmentIndex = 1
            case "Assignment" :
                categorySegmentControl.selectedSegmentIndex = 2
            default:
                categorySegmentControl.selectedSegmentIndex = 0
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func categoryTapped(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            taskCategory = "ToDo"
        case 1:
            taskCategory = "Shopping"
        case 2:
            taskCategory = "Assignment"
        default:
            taskCategory = "ToDo"
        }
    }
    
    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func plusBtnTapped(_ sender: UIButton) {
        let taskName = taskTextField.text
        
        if taskName == ""{
            dismiss(animated: true, completion: nil)
            return
        }
        
        //受け取った値が空であれば、新しいTask型オブジェクトを作成する
        if task == nil{
        //taskにDBのエンティティを代入
            task = Task(context: context)
        }
        
        //受け取った値があれば、その値を代入
        if let task = task{
            task.name = taskName
            task.category = taskCategory
        }
        //作成したデータをDBに保存
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        dismiss(animated: true, completion: nil)
    }

}
