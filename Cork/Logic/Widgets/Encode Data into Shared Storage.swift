//
//  Encode Data into Shared Storage.swift
//  Cork
//
//  Created by David Bureš on 07.10.2023.
//

import Foundation

enum DataInsertionIntoSharedStorageError: Error
{
    case couldNotEncode
}

func insertDataIntoSharedStorage(_ object: Codable, dataType: SharedDataType) throws
{
    do
    {
        let objectData = try JSONEncoder().encode(object)

        UserDefaults(suiteName: "group.com.davidbures.Cork")!.set(objectData, forKey: dataType.rawValue)
    }
    catch
    {
        throw DataInsertionIntoSharedStorageError.couldNotEncode
    }
}
