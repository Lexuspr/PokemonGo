//
//  ViewController.swift
//  PokemonGo
//
//  Created by MAC10 on 18/06/18.
//  Copyright © 2018 tecsup. All rights reserved.
//
import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var ubicacion = CLLocationManager()
    var contActualizaciones = 0
    var pokemons:[Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ubicacion.delegate = self
        pokemons = obtenerPokemon()
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            setup()
        } else {
            ubicacion.requestWhenInUseAuthorization()
        }
    }
    
    func setup() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        ubicacion.startUpdatingLocation()
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
            if let coord = self.ubicacion.location?.coordinate{
                //let pin = MKPointAnnotation()
                //pin.coordinate = coord
                let pokemon = self.pokemons[Int(arc4random_uniform(UInt32(self.pokemons.count)))]
                let pin = PokePin(coord: coord, pokemon: pokemon)
                let randomLat = (Double(arc4random_uniform(200))-100.0)/5000.0
                let randomLon = (Double(arc4random_uniform(200))-100.0)/5000.0
                pin.coordinate.latitude += randomLat
                pin.coordinate.longitude += randomLon
                self.mapView.addAnnotation(pin)
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if contActualizaciones < 1 {
            let region = MKCoordinateRegionMakeWithDistance(ubicacion.location!.coordinate, 1000, 1000)
            mapView.setRegion(region, animated: true)
            contActualizaciones += 1
        } else {
            ubicacion.stopUpdatingLocation()
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            let pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            pinView.image = UIImage(named: "player")
            var frame = pinView.frame
            frame.size.height = 50
            frame.size.width = 50
            pinView.frame = frame
            return pinView
        }
        
        let pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        //pinView.image = UIImage(named: "mew")
        let pokemon = (annotation as! PokePin).pokemon
        pinView.image = UIImage(named: pokemon.imagenNombre!)
        var frame = pinView.frame
        frame.size.height = 50
        frame.size.width = 50
        pinView.frame = frame
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        if view.annotation is MKUserLocation {
            return
        }
        let region = MKCoordinateRegionMakeWithDistance((view.annotation?.coordinate)!, 500, 500)
        mapView.setRegion(region, animated: true)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
            if let coord = self.ubicacion.location?.coordinate{
                let pokemon = (view.annotation as! PokePin).pokemon
                if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coord)){
                    print("Puede atrapar el pokemon")
                    if pokemon.cantidad != 0 {
                        let alertaVC = UIAlertController(title: "Mira!!!!", message: "Ya tienes a ese pokemon, ¿aún asi deseas capturarlo?", preferredStyle: .alert)
                        let yesAction = UIAlertAction(title: "Si", style: .default, handler: {(action) in
                            pokemon.atrapado = true
                            pokemon.cantidad += 1
                            (UIApplication.shared.delegate as! AppDelegate).saveContext()
                            mapView.removeAnnotation(view.annotation!)
                        })
                        alertaVC.addAction(yesAction)
                        let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
                        alertaVC.addAction(noAction)
                        self.present(alertaVC, animated: true, completion: nil)
                    } else {
                        //empieza atrapar pokemon
                        pokemon.atrapado = true
                        pokemon.cantidad += 1
                        (UIApplication.shared.delegate as! AppDelegate).saveContext()
                        mapView.removeAnnotation(view.annotation!)
                        //mensaje atrapar Pokemon
                        let alertaVC = UIAlertController(title: "Felicidades!!!", message: "Atrapaste un \(pokemon.nombre!)", preferredStyle: .alert)
                        let pokedexAccion = UIAlertAction(title: "Pokedex", style: .default, handler: {(action) in
                            self.performSegue(withIdentifier: "pokedexSegue", sender: nil)
                        })
                        alertaVC.addAction(pokedexAccion)
                        let okAccion = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertaVC.addAction(okAccion)
                        self.present(alertaVC, animated: true, completion: nil)
                        // fin mensaje atrapar Pokemon
                    }
                } else {
                    let alertaVC = UIAlertController(title: "Upss", message: "Estas lejos de ese \(pokemon.nombre!)", preferredStyle: .alert)
                    let okAccion = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertaVC.addAction(okAccion)
                    self.present(alertaVC, animated: true, completion: nil)
                    print("No se puede atrapar el pokemon")
                }
            }
        }
        //print("PIN presionado!")
    )}
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            setup()
        }
    }

    @IBAction func centrarTapped(_ sender: UIButton) {
        if let coord = ubicacion.location?.coordinate{
            let region = MKCoordinateRegionMakeWithDistance(coord, 1000, 1000)
            mapView.setRegion(region, animated: true)
            contActualizaciones += 1
        }
    }
}

