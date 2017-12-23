//
//  ConsultationTableVC.swift
//  Apollo
//
//  Created by Lonewulf on 12/23/17.
//  Copyright © 2017 Lonewulf. All rights reserved.
//

import UIKit
import RealmSwift

class ConsultationTableVC: SwipeTableViewController {

    
    var records: Results<Record>?
    
    let realm = try! Realm()
    
    var selectedPatient : Patient? {
        didSet{
            loadRecords()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let record = records?[indexPath.row] {
            
            cell.textLabel?.text = record.title
            
//            cell.accessoryType = record.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No record Added"
        }
        return cell
        
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let record = records?[indexPath.row]{
//            do {
//                try realm.write(record)
//            } catch {
//                print("Error saving done status , \(error)")
//            }
//        }
//
//
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add new Record", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Record", style: .default) { (action) in
            
            if let currentPatient = self.selectedPatient {
                do {
                    try self.realm.write {
                        let newRecord = Record()
                        newRecord.title = textfield.text!
                        newRecord.dateCreated = Date()
                        currentPatient.records.append(newRecord)
                    }
                } catch {
                    print("Error saving new item, \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textfield = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK: - Data manipulations
    
    func loadRecords() {
        
        records = selectedPatient?.records.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let record = records?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(record)
                }
            } catch {
                print("Error deleting record, \(error)")
            }
        }
    }
}

//MARK: - Search bar methods
extension ConsultationTableVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        records = records?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadRecords()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}
