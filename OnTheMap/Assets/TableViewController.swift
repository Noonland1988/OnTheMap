//
//  TableViewController.swift
//  OnTheMap
//
//  Created by 嶋田省吾 on 2021/09/30.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    @IBOutlet weak var addInfoButton: UIBarButtonItem!
        
    @IBAction func refreshTapped(_ sender:UIBarButtonItem){
        print("refreshbuttonTapped")
        getStudentListHandler()
    }
    
    var studentList = [results]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getStudentListHandler()
    }
    
    //get studentList
    func getStudentListHandler(){
        studentList.removeAll()
        OTMClient.gettingStudentLocation(options: "limit=100&order=-updatedAt"){ response, error in
            if let response = response {
                DispatchQueue.main.async {
                    self.studentList = response.results
                    self.tableView.reloadData()
                }
            } else {
                print("could not find StudentList")
            }
        }
    }
    
    

    // MARK: - Table view data source
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentList.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath)
        let studentCalled = studentList[(indexPath as NSIndexPath).row]

        cell.textLabel!.text =  studentCalled.firstName + " " + studentCalled.lastName
        cell.detailTextLabel!.text = studentCalled.mediaURL
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Open the link
        let studentLink = studentList[indexPath.row].mediaURL
        openLink(url: studentLink)
    }

}
