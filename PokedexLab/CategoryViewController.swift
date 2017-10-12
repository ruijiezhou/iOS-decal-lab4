//
//  CategoryViewController.swift
//  PokedexLab
//
//  Created by SAMEER SURESH on 2/25/17.
//  Copyright © 2017 iOS Decal. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var categoryTableView: UITableView!
    
    var pokemonArray: [Pokemon]?
    var cachedImages: [Int:UIImage] = [:]
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (pokemonArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokeCell", for: indexPath) as! CategoryTableViewCell
        
        let pokemon = pokemonArray![indexPath.item]
        
        if let image = cachedImages[indexPath.row] {
            cell.pokeImage.image = image
        } else {
            
            let url = URL(string: pokemon.imageUrl)!
            let session = URLSession(configuration: .default)
            let downloadPicTask = session.dataTask(with: url) { (data, response, error) in
                if let e = error {
                    print("Error downloading picture: \(e)")
                } else {
                    if let _ = response as? HTTPURLResponse {
                        if let imageData = data {
                            let image = UIImage(data: imageData)
                            self.cachedImages[indexPath.row] = image
                            DispatchQueue.main.async {
                                cell.pokeImage.image = UIImage(data: imageData) // may need to
                            }
                        } else {
                            print("Couldn't get image: Image is nil")
                        }
                    } else {
                        print("Couldn't get response code")
                    }
                }
            }
            downloadPicTask.resume()
        }
        
        cell.pokeName.text = pokemon.name
        cell.pokeNumber.text = "#" + String(describing: pokemon.number!)
        cell.pokeStats.text = String(describing: pokemon.attack!) + "/" + String(describing: pokemon.defense!) + "/" + String(describing: pokemon.health!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "categoryPoke", sender: selectedIndexPath?.item)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "categoryPoke" {
            if let destination = segue.destination as? PokemonInfoViewController {
                destination.pokemon = pokemonArray?[(selectedIndexPath?.item)!]
                destination.image = cachedImages[(selectedIndexPath?.item)!]
            }
        }
    }
    
    
}
