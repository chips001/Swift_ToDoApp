//
//  ViewController.swift
//  ToDoApp
//
//  Created by 一木 英希 on 2017/11/05.
//  Copyright © 2017年 一木 英希. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    @IBOutlet weak var taskTableView: UITableView!
//    @IBOutlet weak var addTaskButton: UIButton!
    
    var tasks:[Task] = []
    var tasksToShow:[String:[String]] = ["ToDo":[], "Shopping":[], "Assignment":[]]
    let taskCategorise:[String] = ["ToDo", "Shopping", "Assignment"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        taskTableView.delegate = self
        taskTableView.dataSource = self
    }
    
    //taskCategotiesに格納されている文字列がTableViewのセクションになる
    func numberOfSections(in tableView: UITableView) -> Int {
        return taskCategorise.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return taskCategorise[section]
    }
    
    //tasksToShowのカテゴリ(tasksToShowのキーとなっている)ごとのnameが格納されている
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksToShow[taskCategorise[section]]!.count
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addTaskBtnTapped(_ sender: AnyObject) {
        let storyboard:UIStoryboard = self.storyboard!
        let addTaskViewController = storyboard.instantiateViewController(withIdentifier: "AddTaskViewController")
        present(addTaskViewController, animated: true, completion: nil)
    }

}

