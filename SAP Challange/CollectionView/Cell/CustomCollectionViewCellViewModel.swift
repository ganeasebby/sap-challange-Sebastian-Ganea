//
//  CustomCollectionViewCellViewModel.swift
//  SAP Challange
//
//  Created by Sebastian Ganea on 18.07.2022.
//

import Foundation
import UIKit

/// the view model used by the collection view cell
struct CustomCollectionViewCellViewModel{
    private let model: SAPModel!
    static let builder = ContentBuilder()
    
    init(model: SAPModel){
        self.model = model
    }
    
    /// will used the builder to return the content to be displayed in the cell
    func getContent() -> UIView{
        do{
            let view = try ContentBuilder().build(model)
            return view
        }
        catch SAPTypeError.unknownModelType(let message){
            let label = UILabel()
            label.text = "Unable to display content. Error: \(message)"
            label.numberOfLines = 0
            label.sizeToFit()
            return label
        }
        catch{
            let label = UILabel()
            label.text = "Somethig went wrong"
            label.numberOfLines = 0
            label.sizeToFit()
            return label
        }
    }
}
