//
//  Patient.swift
//  Apollo
//
//  Created by Lonewulf on 12/23/17.
//  Copyright © 2017 Lonewulf. All rights reserved.
//

import Foundation
import RealmSwift

class Patient: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var dateAdded: Date?
    let records = List<Record>()
}

