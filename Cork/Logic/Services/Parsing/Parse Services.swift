//
//  Parse Services.swift
//  Cork
//
//  Created by David Bureš on 20.03.2024.
//

import Foundation
import SwiftyJSON

func parseServices(rawOutput: String) throws -> Set<HomebrewService>
{
    var servicesTracker: Set<HomebrewService> = .init()
    
    guard let rawOutputAsData: Data = rawOutput.data(using: .utf8, allowLossyConversion: false) else
    {
        throw JSONError.conversionToDataFailed
    }
    
    do
    {
        let servicesArray: [HomebrewService] = try AppConstants.jsonDecoder.decode([HomebrewService].self, from: rawOutputAsData)
        
        for service in servicesArray
        {
            
            servicesTracker.insert(service)
        }
        
        return servicesTracker
    }
    catch let parsingError
    {
        AppConstants.logger.error("PArsing of services failed: \(parsingError)")
        throw JSONError.parsingFailed
    }
}
