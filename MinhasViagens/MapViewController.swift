//
//  MapViewController.swift
//  MinhasViagens
//
//  Created by Felipe Augusto Correia on 06/02/23.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var gerenciadorDeLocalizacao = CLLocationManager()
    @IBOutlet var mapa: MKMapView!
    
    // Dicionario
    var viagem: Dictionary<String,String> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuraGerenciadorDeLocalizacao()
        
        let reconhecedorDeGesto = UILongPressGestureRecognizer(target: self, action: #selector(marcar(gesture: )))
        
        reconhecedorDeGesto.minimumPressDuration = 2
        
        mapa.addGestureRecognizer(reconhecedorDeGesto)
    }
    
    
    @objc func marcar(gesture: UIGestureRecognizer) {
        
        if gesture.state == UIGestureRecognizer.State.began {
            
            
            let pontoSelecionado = gesture.location(in: self.mapa)
            
            
            let coordenadas = mapa.convert(pontoSelecionado, toCoordinateFrom: self.mapa)
            
            
            let anotacao = MKPointAnnotation()
            
            anotacao.coordinate.latitude = coordenadas.latitude
            anotacao.coordinate.longitude = coordenadas.longitude
            
            let localizacao = CLLocation(latitude: coordenadas.latitude, longitude: coordenadas.longitude)
            
            var localCompleto = "Endereço não encontrado"
            
            CLGeocoder().reverseGeocodeLocation(localizacao) { (local, erro) in
                
                if erro == nil {
                    
                    if let dadosLocal = local?.first {
                        if let nome = dadosLocal.name {
                            localCompleto = nome
                        } else {
                            if let endereco = dadosLocal.thoroughfare {
                                localCompleto = endereco
                            }
                        }
                    }
                    
                    self.viagem = ["local": localCompleto, "latitude": String(coordenadas.latitude), "longitude": String(coordenadas.longitude)]
                    ArmazenamentoDeDados().salvarViagem(viagem: self.viagem)
                    
                    print(ArmazenamentoDeDados().listarViagens())
                    
                    anotacao.title = localCompleto
                    self.mapa.addAnnotation(anotacao)
                    
                } else {
                    print(erro as Any)
                }
            }
        }
    }
    
    
    func configuraGerenciadorDeLocalizacao() {
        gerenciadorDeLocalizacao.delegate = self
        gerenciadorDeLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorDeLocalizacao.requestWhenInUseAuthorization()
        gerenciadorDeLocalizacao.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status != .authorizedWhenInUse {
            
            let alertaController = UIAlertController(title: "Permissão de Localização", message: "Necessário permissão para que o aplicativo acesse sua localização.", preferredStyle: UIAlertController.Style.alert)
            let configuracoes = UIAlertAction(title: "Configurações", style: UIAlertAction.Style.default) { (alertaConfiguracoes) in
                
                
                if let configuracoes = NSURL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open( configuracoes as URL)
                }
            }
            
            let acaoCancelar = UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.default, handler: nil)
            
            alertaController.addAction(configuracoes)
            alertaController.addAction(acaoCancelar)
            
            present(alertaController, animated: true, completion: nil)
            
        }
        
    }
    
}
