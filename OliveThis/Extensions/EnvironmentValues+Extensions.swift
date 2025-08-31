//
//  EnvironmentValues+Extensions.swift
//  OliveThis
//
//  Created by Beryl Bucher on 8/30/25.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    
    @Entry var authenticationController = AuthenticationController(httpClient: HTTPClient())
    
}
