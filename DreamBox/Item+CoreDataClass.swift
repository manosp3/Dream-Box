//
//  Item+CoreDataClass.swift
//  DreamBox
//
//  Created by Emmanouil Perakis on 04/08/2017.
//  Copyright © 2017 Emmanouil Perakis. All rights reserved.
//

import Foundation
import CoreData


public class Item: NSManagedObject {
    
    public override func awakeFromInsert() {
        
        super.awakeFromInsert()
        
        self.created = NSDate()
    }
    
}
