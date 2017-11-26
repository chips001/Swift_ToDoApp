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
    @IBOutlet weak var caregorySegmentControl: UISegmentedControl!
    var taskCategory = "ToDo"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        //contextを定義
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        //taskにDBのエンティティを代入
        let task = Task(context: context)
        
        //先ほど定義したname,categoryに選択したデータを代入
        task.name = taskName
        task.category = taskCategory
        
        //作成したデータをDBに保存
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
