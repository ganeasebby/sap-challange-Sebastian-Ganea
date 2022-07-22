//
//  CustomCollectionViewCellViewModel.swift
//  SAP Challange
//
//  Created by Sebastian Ganea on 18.07.2022.
//

import Foundation
import UIKit

struct CustomCollectionViewCellViewModel{
    let titleString: String?
    let descriptionString: String?
    
    init(model: SAPModel){
        titleString = model.titleStr
        descriptionString = model.textviewStr
    }
}
