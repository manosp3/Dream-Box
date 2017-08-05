//
//  MainVC.swift
//  DreamBox
//
//  Created by Emmanouil Perakis on 04/08/2017.
//  Copyright © 2017 Emmanouil Perakis. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    //fetchedresultcontroller: collects information about the results without the need to fetch all the results
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var segment: UISegmentedControl!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var controller: NSFetchedResultsController<Item>!
        
        tableView.delegate = self
        tableView.dataSource = self
        

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func attemptFetch() {
        //Passing a fetched requested item.
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        //how to sort the results
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        //perform the actual fetch
        do {
            
            try controller.performFetch()
        } catch {
            
            let error = error as NSError
            print(error)
        
        }
    }
    
    //this when the tableview is ready to update this will start to listen for any changes and will handle it for you
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        
        tableView.beginUpdates()
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.endUpdates()
    
    }
    
    //this is gonna be listening for when we are making a change (insertion,deletion,move,update etc.)
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch(type) {
            
        case.insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = newIndexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                //update the cell data
            }
            break
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }    

}












