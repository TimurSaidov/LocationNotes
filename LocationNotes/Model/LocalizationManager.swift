//
//  LocalizationManager.swift
//  LocationNotes
//
//  Created by Timur Saidov on 13/11/2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import Foundation

extension String {
    func localize() -> String {
        return NSLocalizedString(self, comment: "") // Локализируется сама строка self.
    }
}
