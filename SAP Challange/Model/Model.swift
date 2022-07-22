//
//  DataSourceModel.swift
//  SAP Challange
//
//  Created by Sebastian Ganea on 18.07.2022.
//

import Foundation

enum ModelType{
    case label
    case textView
}

protocol SAPModel{
    var type: ModelType { get }
    var text: String? { get set }
}

struct LabelModel: SAPModel {
    let type: ModelType = .label
    var text: String?
}

struct TextViewModel: SAPModel{
    let type: ModelType = .textView
    var text: String?
}
