//
//  PokedexViewController.swift
//  PokemonGo
//
//  Created by MAC10 on 18/06/18.
//  Copyright © 2018 tecsup. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    
    var pokemonsAtrapados:[Pokemon] = []
    var pokemonsNoAtrapados:[Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
        
        pokemonsAtrapados = obtenerPokemonsAtrapados()
        pokemonsNoAtrapados = obtenerPokemonsNoAtrapados()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return pokemonsAtrapados.count
        } else {
            return pokemonsNoAtrapados.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokemon:Pokemon
        let cell = UITableViewCell()
        if indexPath.section == 0 {
            pokemon = pokemonsAtrapados[indexPath.row]
            cell.textLabel?.text = "\((pokemon.nombre)!)  - Tienes \(pokemon.cantidad)"
        } else {
            pokemon = pokemonsNoAtrapados[indexPath.row]
            cell.textLabel?.text = pokemon.nombre!
            cell.isEditing = false
        }
        cell.detailTextLabel?.text = "Tienes \(pokemon.cantidad)"
        cell.imageView?.image = UIImage(named: pokemon.imagenNombre!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0 {
                let pokemon = pokemonsAtrapados[indexPath.row]
                /*let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                context.delete(pokemon)
                 (UIApplication.shared.delegate as! AppDelegate).saveContext()*/
                pokemon.cantidad -= 1
                if pokemon.cantidad == 0 {
                    pokemonsAtrapados.remove(at: indexPath.row)
                    pokemon.atrapado = false
                    pokemonsNoAtrapados.append(pokemon)
                }
                //context.insert(pokemon)
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                
                tableView.reloadData()
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Atrapados"
        } else {
            return "No Atrapados"
        }
    }

    @IBAction func mapTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
