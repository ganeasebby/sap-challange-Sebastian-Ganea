//
//  DataSourceModel.swift
//  SAP Challange
//
//  Created by Sebastian Ganea on 18.07.2022.
//

import Foundation

struct BasicSAPModelTypes {
     static let labelType = 1
     static let textViewType = 2
 }

protocol SAPModel{
    var type: Int { get }
    var text: String? { get set }
}

struct LabelModel: SAPModel {
    let type  = BasicSAPModelTypes.labelType
    var text: String?
}

struct TextViewModel: SAPModel{
    let type  = BasicSAPModelTypes.textViewType
    var text: String?
}
