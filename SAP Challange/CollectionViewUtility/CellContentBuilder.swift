//
//  Builder.swift
//  SAP Challange
//
//  Created by Sebastian Ganea on 25.07.2022.
//

import Foundation
import UIKit

/// Used to for building the content of the collectionviewcells based on the model
struct ContentBuilder{
    
    /// builds the view that needs to be displayed by the cell based on the model
    func build(_ model: SAPModel) -> UIView{
        switch model.type{
            
        case .label:
            return LabelContent(text: model.text)
            
        case .textView:
            return TextViewContent(text: model.text)
        }
    }
}
