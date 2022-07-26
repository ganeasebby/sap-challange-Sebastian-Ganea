//
//  CustomCollectionViewCellViewModel.swift
//  SAP Challange
//
//  Created by Sebastian Ganea on 18.07.2022.
//

import Foundation
import UIKit

struct CustomCollectionViewCellViewModel{
    private let model: SAPModel!
    
    init(model: SAPModel){
        self.model = model
    }
    
    func getContent() -> UIView{
        return ContentBuilder().build(model)
    }
}
