//
//  ArmazenamentoDeDados.swift
//  MinhasViagens
//
//  Created by Felipe Augusto Correia on 06/02/23.
//

import Foundation
import UIKit

class ArmazenamentoDeDados {
    
    let chaveArmazenamento = "locaisViagem"
    
    // array de dicionários
    var viagens: [Dictionary<String, String>] = []
    
    func getDefaults() -> UserDefaults {
        return UserDefaults.standard
    }
    
    
    func salvarViagem(viagem: Dictionary<String, String>) {
        
        viagens = listarViagens()
        
        viagens.append(viagem)
        
        getDefaults().set(viagens, forKey: chaveArmazenamento)
        getDefaults().synchronize()
    }
    
    func listarViagens() -> [Dictionary<String, String>] {
        
        let dados = getDefaults().object(forKey: chaveArmazenamento)
        
        if dados != nil {
            return dados as! [Dictionary<String, String>]
        } else {
            return []
        }
    }
    
    func removerViagem(indice: Int) {
        
        viagens = listarViagens()
        
        viagens.remove(at: indice)
        
        getDefaults().set(viagens, forKey: chaveArmazenamento)
        
        getDefaults().synchronize()
    }
}
