//
//  CustomCollectionViewCellViewModel.swift
//  SAP Challange
//
//  Created by Sebastian Ganea on 18.07.2022.
//

import Foundation
import UIKit

struct CustomCollectionViewCellViewModel{
    let text: String?
    let type: ModelType!
    
    init(model: SAPModel){
        self.type = model.type
        self.text = model.text
    }
}
