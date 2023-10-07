//
//  Decode Data from Shared Storage.swift
//  Cork
//
//  Created by David Bureš on 07.10.2023.
//

import Foundation

enum DataRetrievalFromSharedStorageError: Error
{
    case couldNotDecode
}

func retrieveDataFromSharedStorage(dataType: SharedDataType) throws -> any Codable
{
    let encodedData = UserDefaults(suiteName: "group.com.davidbures.Cork")!.object(forKey: dataType.rawValue) as? Data

    if let objectEncoded = encodedData
    {

        var decodedObject: Codable?

        switch dataType {
            case .outdatedPackages:
                decodedObject = try? JSONDecoder().decode(OutdatedPackage.self, from: objectEncoded)
            case .homebrewStats:
                decodedObject = try? JSONDecoder().decode(HomebrewStats.self, from: objectEncoded)
        }

        return decodedObject!
    }
    else
    {
        throw DataRetrievalFromSharedStorageError.couldNotDecode
    }
}
