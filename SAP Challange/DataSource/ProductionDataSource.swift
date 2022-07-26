//
//  ProductionDataSource.swift
//  SAP Challange
//
//  Created by Sebastian Ganea on 25.07.2022.
//

import Foundation

class ProductionDataSource: DataSourceProtocol {
    private init() {}
    
    /// returns an array of model that is used to populate the collectionview.
    func getData() -> [SAPModel]{
        return []
    }

}
