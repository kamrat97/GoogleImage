//
//  Extension.swift
//  Image
//
//  Created by Влад on 06.07.2022.
//

import Foundation
import UIKit

extension String {
    var encodeUrl : String {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
}
