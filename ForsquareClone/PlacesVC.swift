//
//  ListViewController.swift
//  ForsquareClone
//
//  Created by Berke Baç on 16.04.2022.
//

import UIKit
import Firebase
class PlacesVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    
    var placeNameArray = [String]()
    var placeIdArray = [String]()
    var selectedPlaceId = ""
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(signOutClicked))
        

        getDataFromFireStore()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destinationVC = segue.destination as! DetailsVC
            destinationVC.chosenPlaceId = selectedPlaceId
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlaceId = placeIdArray[indexPath.row]
        self.performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    
    
    
    func getDataFromFireStore () {
        
        let fireStoreDataBase = Firestore.firestore()
        
        fireStoreDataBase.collection("Places").addSnapshotListener { snapshot, error in
            if error != nil {
                self.MakeAlert(tittleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
            }else {
                if snapshot?.isEmpty != true {
                    self.placeIdArray.removeAll(keepingCapacity: false)
                    self.placeNameArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        if let placeID = document.documentID as? String {
                            if let placeName = document.get("name") as? String {
                                self.placeNameArray.append(placeName)
                                self.placeIdArray.append(placeID)
                            }
                        }
                       
                    }
                    self.tableView.reloadData()
                      
                }
            }
            
        }
    }
    
    func MakeAlert (tittleInput : String, messageInput : String){
        let alert = UIAlertController(title: tittleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func signOutClicked(){
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toSignUpVC", sender: nil)
        }catch {
            print("error")
        }
    }
    
    @objc func addButtonClicked(){
        performSegue(withIdentifier: "toAddVC", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = placeNameArray[indexPath.row]
        return cell
    }

    

}
