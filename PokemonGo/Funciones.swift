//
//  Funciones.swift
//  PokemonGo
//
//  Created by MAC10 on 18/06/18.
//  Copyright © 2018 tecsup. All rights reserved.
//

import UIKit
import CoreData

func crearPokemon(xnombre: String, ximagenNombre:String, xcantidad:Int32){
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let pokemon = Pokemon(context: context)
    pokemon.nombre = xnombre
    pokemon.imagenNombre = ximagenNombre
    pokemon.cantidad = xcantidad
}

func agregarPokemons(){
    crearPokemon(xnombre: "Mew", ximagenNombre: "mew", xcantidad: 0)
    crearPokemon(xnombre: "Meowth", ximagenNombre: "meowth", xcantidad: 0)
    crearPokemon(xnombre: "Abra", ximagenNombre: "abra", xcantidad: 0)
    crearPokemon(xnombre: "Bullbasaur", ximagenNombre: "bullbasaur", xcantidad: 0)
    crearPokemon(xnombre: "Caterpie", ximagenNombre: "caterpie", xcantidad: 0)
    crearPokemon(xnombre: "Charmander", ximagenNombre: "charmander", xcantidad: 0)
    crearPokemon(xnombre: "Dratini", ximagenNombre: "dratini", xcantidad: 0)
    crearPokemon(xnombre: "Eevee", ximagenNombre: "eevee", xcantidad: 0)
    crearPokemon(xnombre: "Jigglypuff", ximagenNombre: "jigglypuff", xcantidad: 0)
    crearPokemon(xnombre: "Mankey", ximagenNombre: "mankey", xcantidad: 0)
    crearPokemon(xnombre: "Pidgey", ximagenNombre: "pidgey", xcantidad: 0)
    crearPokemon(xnombre: "Pikachu", ximagenNombre: "pikachu", xcantidad: 0)
    crearPokemon(xnombre: "Psyduck", ximagenNombre: "psyduck", xcantidad: 0)
    crearPokemon(xnombre: "Rattata", ximagenNombre: "rattata", xcantidad: 0)
    crearPokemon(xnombre: "Snorlax", ximagenNombre: "snorlax", xcantidad: 0)
    crearPokemon(xnombre: "Squirtle", ximagenNombre: "squirtle", xcantidad: 0)
    crearPokemon(xnombre: "Venonat", ximagenNombre: "venonat", xcantidad: 0)
    crearPokemon(xnombre: "Weedle", ximagenNombre: "weedle", xcantidad: 0)
    crearPokemon(xnombre: "Zubat", ximagenNombre: "zubat", xcantidad: 0)
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
}

func obtenerPokemon()-> [Pokemon]{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    do{
        let pokemons = try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
        if pokemons.count == 0{
            agregarPokemons()
            return obtenerPokemon()
        }
        return pokemons
    }catch{}
    return []
}

func obtenerPokemonsAtrapados()-> [Pokemon]{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let queryConWhere = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    queryConWhere.predicate = NSPredicate(format: "atrapado == %@", NSNumber(value: true))
    do{
        let pokemons = try context.fetch(queryConWhere) as [Pokemon]
        return pokemons
    }catch{}
    return []
}

func obtenerPokemonsNoAtrapados()-> [Pokemon]{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let queryConWhere = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    queryConWhere.predicate = NSPredicate(format: "atrapado == %@", NSNumber(value: false))
    do{
        let pokemons = try context.fetch(queryConWhere) as [Pokemon]
        return pokemons
    }catch{}
    return []
}
