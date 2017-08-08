//
//  ItemDetailsVC.swift
//  DreamBox
//
//  Created by Emmanouil Perakis on 06/08/2017.
//  Copyright © 2017 Emmanouil Perakis. All rights reserved.
//

import UIKit
import CoreData

// opos kai sto tableview etsi kai sto pickerbiew thelo afta ta properties
class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var PriceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    
    @IBOutlet weak var thumgImg: UIImageView!
    
    var stores = [Store]()
    var itemToEdit: Item?
    
    //ftiaxnoume ena imagepicker, min ksexaseis ta properties stin arxi!
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        //anagkastika gia to pickerview
        storePicker.delegate = self
        storePicker.dataSource = self
        
        //kai afta gia to image picker
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        
        //ETSI Dimiourgoume entities sto coredata
//        let store = Store(context: context)
//        store.name = "Best Buy"
//        let store2 = Store(context: context)
//        store2.name = "Tesla Dealership"
//        let store3 = Store(context: context)
//        store3.name = "Frys Electronics"
//        let store4 = Store(context: context)
//        store4.name = "Target"
//        let store5 = Store(context: context)
//        store5.name = "Amazon"
//        let store6 = Store(context: context)
//        store6.name = "K Mart"
       // meta sozoume ta data mas kai stelnonte monima stin coredata
//        ad.saveContext()
        
        getStores()
        
        //an exoume dosi item tote na to fortosei
        if itemToEdit != nil {
            loadItemData()
        }
    }
    
    //sets the title for the row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        //to var row na prosekseis
        let store = stores[row]
        // to .name einai entity apo to core data    
        return store.name
        
    }
    
    //poses grammes tha exei to pickerview mas
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return stores.count
    }
    
    //posa stiles tha exei to pickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    //an epileksi kapia o xristis
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // update when seelcted
    }
    
    //fetch request gia na paroume ta dedomena(stores)
    func getStores() {
        
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        //mporei na dwsei error gi afto vazo to do,catch
        do {
            //edo leei: set the fetched results sto store array mas
            self.stores = try context.fetch(fetchRequest)
            //reloads all the component in the storepicker
            self.storePicker.reloadAllComponents()
            
        } catch {
            
            // handle the error
        }
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        var item: Item!
        let picture = Image(context: context)
        picture.image = thumgImg.image
        
        //edo ean kanoume edit afto pou valame sa dedomeno tote de ftiaxnei kainourgio item alla ananeonei afto pou eixame idi
        if itemToEdit == nil {
            
            item = Item(context: context)
            
        } else {
            
            item = itemToEdit
            
        }
        
        item.toImage = picture
        
        
        //Vlepoume an ontos exei timi to pedio stin efarmogi mas(to idio kai gia tis alles metavlites)
        //afta , title price einai atributes idi
        if let title = titleField.text {
            
            item.title = title
            
        }
        
        if let price = PriceField.text {
            //to kano NSString kai oxi aplo string giati thelo na xrisimopoiiso kapia methods tou NSString opos double to string conversion px
            item.price = (price as NSString).doubleValue
            
        }
        
        if let details = detailsField.text {
            
            item.details = details
            
        }
        
        //eno afta einai entities kai behaviours
        //edo vazoume ena store apo to relationship pou exei me ti item
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        
        ad.saveContext()
        
        //Afto mas paei piso sto viewcontroller otan telika patisoume to save button!!
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    func loadItemData() {
        
        if let item = itemToEdit {
            
            titleField.text = item.title
            PriceField.text = "\(item.price)"
            detailsField.text = item.details
            thumgImg.image = item.toImage?.image as? UIImage
            
            //etsi vazoume to store, pernaei ena pros ena ta magazia pou exoume valei mexri na crei afto pou teriazei kai na to apothikefsei
            if let store = item.toStore {
                
                var index = 0
                repeat {
                    
                    let s = stores[index]
                    if s.name == store.name {
                        
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                    
                } while (index < stores.count)
            }
        }
        
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func addImage(_ sender: UIButton) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    //anagkastiko gia na ftiaksoume to imagepicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            thumgImg.image = img
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
}






