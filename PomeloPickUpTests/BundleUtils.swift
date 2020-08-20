//
//  BundleUtils.swift
//  PomeloPickUpTests
//
//  Created by n.rathod on 20/8/2563 BE.
//  Copyright © 2563 Nilesh. All rights reserved.
//

import Foundation
import Alamofire
@testable import PomeloPickUp

class MockClassBundle {}
extension Bundle {
    static func createModelFileJson(fileName: String) -> LocationInfoModel? {
        let bundle = Bundle(for: MockClassBundle.self)
        let decoder = JSONDecoder()
        guard let path = bundle.path(forResource: fileName, ofType: "json") else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let results = try decoder.decode(LocationInfoModel.self, from: data)
            return results
        } catch {
            // handle error
            print(error.localizedDescription)
            return nil
        }
        
        return nil
    }
}
