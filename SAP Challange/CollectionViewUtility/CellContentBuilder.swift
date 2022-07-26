//
//  Builder.swift
//  SAP Challange
//
//  Created by Sebastian Ganea on 25.07.2022.
//

import Foundation
import UIKit

protocol ContentBuilderProtocol {
    func build(_ model: SAPModel) throws -> UIView
}

/// Used  for building the content of the collectionviewcells based on the model
class ContentBuilder: ContentBuilderProtocol{
    static var builder: ContentBuilderProtocol?
    
    /// builds the view that needs to be displayed by the cell based on the model
    func build(_ model: SAPModel) throws -> UIView {
        
        switch model.type{
            
        case BasicSAPModelTypes.labelType:
            return LabelContent(text: model.text)
            
        case BasicSAPModelTypes.textViewType:
            return TextViewContent(text: model.text)
        default:
            throw SAPTypeError.unknownModelType("Unknown SAP Model Type")
        }
    }
}
