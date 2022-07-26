//
//  DatasourceFactory.swift
//  SAP Challange
//
//  Created by Sebastian Ganea on 22.07.2022.
//

import Foundation

protocol DataSourceProtocol {
    func getData() -> [SAPModel]
}

/// Used to get feed the data to the collection view
class DataSourceFactory {
    /// current instance of datasource factory
    static var shared: DataSourceFactory?
    
    /// the factory with which the instance was initiaslised (test or production)
    let factory: DataSourceProtocol

    init(factory: DataSourceProtocol) {
        self.factory = factory
    }

    /// retrieves the data that will be used to populate the collectionview
    func getData() -> [SAPModel]{
        factory.getData()
    }
}






