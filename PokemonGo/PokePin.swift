//
//  PokePin.swift
//  PokemonGo
//
//  Created by MAC10 on 18/06/18.
//  Copyright © 2018 tecsup. All rights reserved.
//

import UIKit
import MapKit

class PokePin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var pokemon:Pokemon
    init(coord: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coord
        self.pokemon = pokemon
    }
}
