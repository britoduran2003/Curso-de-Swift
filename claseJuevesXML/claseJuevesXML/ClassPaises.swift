//
//  ClassPaises.swift
//  claseJuevesXML
//
//  Created by user233135 on 2/2/23.
//

import UIKit

class Paises: NSObject {
    var pais: String
    var capital: String
    var superficie: Int
    
    init(pais: String, capital: String, superficie: Int) {
        self.pais = pais
        self.capital = capital
        self.superficie = superficie
    }
}
