//
//  ViewController.swift
//  Apollo
//
//  Created by Lonewulf on 12/23/17.
//  Copyright © 2017 Lonewulf. All rights reserved.
//

import UIKit
import RealmSwift

class RecentTableVC: SwipeTableViewController {

    let realm = try! Realm()
    
    var patients: Results<Patient>?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadPatients()
        
    }
    
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return patients?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = patients?[indexPath.row].name ?? "No Patients Added yet"
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToConsultation", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ConsultationTableVC
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedPatient = patients?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func save(patient: Patient) {
        do {
            try realm.write {
                realm.add(patient)
            }
        } catch {
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadPatients() {
        
        patients = realm.objects(Patient.self).sorted(byKeyPath: "dateAdded", ascending: false)
        l
        tableView.reloadData()
    }
    
    //MARK: - Delete Data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let patientForDeletion = self.patients?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(patientForDeletion)
                }
            } catch {
                print("Error deleting a patient, \(error)")
            }
        }
    }
    
    //MARK: - Add New Patient
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add new patient", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add patient", style: .default) { (action) in
            
            let newPatient = Patient()
            newPatient.name = textfield.text!
            newPatient.dateAdded = Date()
            self.save(patient: newPatient)
            
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Add new category"
            textfield = alertTextfield
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
}

