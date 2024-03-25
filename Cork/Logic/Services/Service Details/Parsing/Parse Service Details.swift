//
//  Parse Service Details.swift
//  Cork
//
//  Created by David Bureš on 21.03.2024.
//

import Foundation
import SwiftyJSON

func parseServiceDetails(rawOutput: String) throws -> ServiceDetails
{
    
    AppConstants.logger.log("Will work with this service details output:\n\(rawOutput)")
    guard let outputAsData: Data = rawOutput.data(using: .utf8, allowLossyConversion: false) else
    {
        throw JSONError.conversionToDataFailed
    }
    
    do
    {        
        let decodedData: [ServiceDetails] = try AppConstants.jsonDecoder.decode([ServiceDetails].self, from: outputAsData)
        
        guard let firstElementInDetailArray: ServiceDetails = decodedData.first else
        {
            AppConstants.logger.error("Could not get first element of service details array")
            throw JSONError.parsingFailed
        }
        return firstElementInDetailArray
    }
    catch let parsingError
    {
        AppConstants.logger.error("Failed while decoding service details: \(parsingError.localizedDescription)")
        throw JSONError.parsingFailed
    }
}
