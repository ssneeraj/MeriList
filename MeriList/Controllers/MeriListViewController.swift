//
//  ViewController.swift
//  MeriList
//
//  Created by Sharma, Neeraj on 12/30/19.
//  Copyright © 2019 Sharma, Neeraj. All rights reserved.
//

import UIKit

class MeriListViewController: UITableViewController {

    private let defaults = UserDefaults.standard
    private var itemArray = [Item]()
    private let dataFile = FileManager.default.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first?.appendingPathComponent("Items.plist")

 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //print(dataFile)
        
        loadItems()
    
//        Read an array from UserDefaults
//        if let items = defaults.array(forKey: "MeriListArray") as? [Item] {
//            for item in items {
//                itemArray.append(Item(name: item.name, checked: item.done))
//            }
//        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }
    
    // MARK: TableView Data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.name
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    // MARK: TableView Delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: 'add' button in NavigationBar tapped
    @objc func addButtonTapped() {
        
        // Create UIAlertController
        let alert = UIAlertController(title: "", message: "Add new item to shoping list", preferredStyle: .alert)
        
        // Add 'Cancel' button to show up in the AlertController
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (uiAlertAction) in
            print("cancel button tapped")
        }))
        
        // Add 'Add' button to show up in the AlertController
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (uiAlertAction) in
            print("add button tapped")

            for action in alert.actions {
                
                if action.style.self == .default {
                    print("\(action.title!)")
                    
                    guard let textField = alert.textFields?[0] else { return }
                    guard let value = textField.text else { return }
                    
                    if !value.isEmpty {
                        print("shopping item enter is \(value)")
                        
                        let item = Item(name: value, checked: false)
                        self.itemArray.append(item)
                        
                        // save the todo list to UserDefaults
                        
                        self.saveItems()
                        
                        break
                    }
                    else {
                        print("no need to add empty item")
                    }
                }
                
            }
        }))
        
        // Add TextField to show up in UIAlertController
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
        }
        
        // Present the UIAlertViewController modally
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Model manipulation
    
    func saveItems() {
        // 1. Create a property list encoder
        let encoder = PropertyListEncoder()
        
        do {
            
            // encode array of custom objects to plist
            let data = try encoder.encode(self.itemArray)
            
            // write the content of encoded data into the location
            
            if let url = self.dataFile {
                do {
                    try data.write(to: url)
                    print("write successful")
                }
                catch {
                    print("error writing encoded items array data to plist ")
                }
            }
        }
        catch {
            print("Error encoding item array \(error)")
        }
        
        // this is to save an array if String
        //self.defaults.setValue(self.itemArray, forKey: "MeriListArray")
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        
        if let url = self.dataFile {
            do {
                let data = try Data(contentsOf: url)
                
                // 2. Create a decoder that will decode data from PropertyList
                
                let decoder = PropertyListDecoder()
                
                do {
                    itemArray = try decoder.decode([Item].self, from: data)
                } catch {
                    print("Error decoding item array, \(error)")
                }
                
                print("write successful")
            }
            catch {
                print("error writing encoded items array data to plist ")
            }
        }
    }
    
    
    
    

}

