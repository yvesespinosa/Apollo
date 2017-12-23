//
//  Record.swift
//  Apollo
//
//  Created by Lonewulf on 12/23/17.
//  Copyright © 2017 Lonewulf. All rights reserved.
//

import Foundation
import RealmSwift

class Record: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var dateCreated: Date?
    var parentPatient = LinkingObjects(fromType: Patient.self, property: "records")
}
