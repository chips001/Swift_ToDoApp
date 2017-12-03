//
//  ViewController.swift
//  ToDoApp
//
//  Created by 一木 英希 on 2017/11/05.
//  Copyright © 2017年 一木 英希. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var taskTableView: UITableView!
    
    var tasks:[Task] = []
    var tasksToShow:[String:[String]] = ["ToDo":[], "Shopping":[], "Assignment":[]]
    let taskCategorise:[String] = ["ToDo", "Shopping", "Assignment"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTableView.delegate = self
        taskTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //CoreDataからデータをfetch
        getDate()
        taskTableView.reloadData()
    }
    
    //編集機能の実装
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destinationViewController = segue.destination as? AddTaskViewController else { return }
        
        //contextをAddTaskViewController.swiftへ渡す
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        destinationViewController.context = context
        
        if let indexPath = taskTableView.indexPathForSelectedRow, segue.identifier == "EditTaskSegue"{
            let editCategory = taskCategorise[indexPath.section]
            let editName = tasksToShow[editCategory]?[indexPath.row]
            
            //得たcategoryとnameに合致するデータのみをgetchするようにfetchRequestを作成
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name = %@ and category = %@", editName!, editCategory)
            
            //fetchRequestを満たすデータをfetchしてtask(配列だが要素を1種類しか持たないはず)に代入し、それを渡す
            do{
                let task = try context.fetch(fetchRequest)
                destinationViewController.task = task[0]
            } catch {
                print("Fetching Failed.")
            }
        }
        
    }
    
    @IBAction func addTaskBtnTapped(_ sender: AnyObject) {
        let storyboard:UIStoryboard = self.storyboard!
        let addTaskViewController = storyboard.instantiateViewController(withIdentifier: "AddTaskViewController")
        present(addTaskViewController, animated: true, completion: nil)
    }
    
    func getDate() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            //CoreDataからデータをfetchしてtasksに格納
            let fatchRequet: NSFetchRequest<Task> = Task.fetchRequest()
            tasks = try context.fetch(fatchRequet)
            
            //tasksToShow配列を空にする(同じデータを複数表示しないため)
            for key in tasksToShow.keys{
                tasksToShow[key] = []
            }
            
            //先ほどfetchしたデータをtasksToShow配列に格納
            for task in tasks {
                tasksToShow[task.category!]?.append(task.name!)
            }
        }catch{
            print("Fetching Failed.")
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    //taskCategotiesに格納されている文字列がTableViewのセクションになる
    func numberOfSections(in tableView: UITableView) -> Int {
        return taskCategorise.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return taskCategorise[section]
    }
    
    //taskCategorise[]の要素をtasksToShowのKey[]と一致させて、そのvalueとなる配列の数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksToShow[taskCategorise[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = taskTableView.dequeueReusableCell(withIdentifier: TaskCell.reuseIdentifier) as? TaskCell else{
            fatalError("create fail")
        }
        
        //変数sectionDataはtaskCategoriseの要素をKeyとして取り出されたArrayである
        let sectionData = tasksToShow[taskCategorise[indexPath.section]]
        
        let cellData = sectionData?[indexPath.row]
        cell.textLabel?.text = cellData
        return cell
    }
    
    //cellをスワイプした時の挙動を実装するDelegateメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if editingStyle == .delete{
            //削除したいデータのみをfetchする
            //削除したいデータのcategoryとnameを取得
            let deleteCategory = taskCategorise[indexPath.section]
            let deleteName = tasksToShow[deleteCategory]? [indexPath.row]
            //先ほど取得したcategoryとnameに合致するデータのみをfetchするようにfetchRequestを作成
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name = %@ and category = %@", deleteName!, deleteCategory)
            
            //そのfetchRequestを満たすデータをfetchしてtask(配列だが1種類しか持たない)に代入し、削除する
            do {
                let task = try context.fetch(fetchRequest)
                context.delete(task[0])
            }catch{
                print("Fetching Failed.")
            }
            
            //削除した後のデータを保存する
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            //削除後の全データをfetchする
            getDate()
        }
        //tableViewを再読み込み
        taskTableView.reloadData()
    }
}

class TaskCell: UITableViewCell{
    
    @IBOutlet weak var taskLavel: UILabel!
    static let reuseIdentifier = "TaskCell"
    
    override func awakeFromNib() {
            super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //cell内アイテムのActionを外部で処理する場合に利用（例：Cell内のButtonAction）
    //    var didTapTestCellHundler: (() -> Void)?
    //    @IBAction func hundleButton(_ sender: UIButton) {
    //        self.didTapTestCellHundler?()
    //    }
    //このdidTapTestCellHundlerをcellForRowで生成したカスタムcustomCellのTap処理のクロージャとして使用する
}
