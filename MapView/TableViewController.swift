//
//  TableViewController.swift
//  TableView
//
//  Created by 903-18i on 16.05.2023.
//

import UIKit

class TableViewController: UITableViewController {

    
    //var array = ["1","2","3"]
    
    //var names = ["April","John", "Clara"]
    //var surnames = ["Kim", "Smith", "Will"]
    //var images = ["AprilKim", "JohnSmith", "ClaraWill"]
    
    var hotels = [Hotel(name: "The Ritz Carlton, Almaty", image: "ritz", address: "Esentai Tower, 7/7 Al-Farabi Avenue, 050040 Almaty, Kazakhstan", rating: 9.1, lat: 31.723610, long: -115.348625),
                  Hotel(name: "Marina Bay Sands", image: "marina", address: "10 Bayfront Avenue, Marina Bay, 018956 Singapore, Singapore", rating: 9.1, lat:1.2838, long: 103.8591),
                  Hotel(name: "Hyatt Regency Köln", image: "hyatt", address: "Kennedy-Ufer 2a, Deutz, 50679 Cologne, Germany", rating: 8.5,lat: 50.9404,long: 6.9692)]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return hotels.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = nil
        
        if indexPath.row % 2 == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        }
        

        // Configure the cell...
        
        let name = cell!.viewWithTag(1000) as! UILabel
        name.text = hotels[indexPath.row].name
        
        let address = cell!.viewWithTag(1001) as! UILabel
        address.text = "Rating: \(hotels[indexPath.row].rating)"
        
        let image = cell!.viewWithTag(1002) as! UIImageView
        image.image = UIImage(named: hotels[indexPath.row].image)

        return cell!
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 149
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "viewController") as! ViewController
       
        viewController.hotel = hotels[indexPath.row]
        
        navigationController?.show(viewController, sender: self)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            hotels.remove(at: indexPath.row)

            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    @IBAction func addContact(_ sender: Any) {
//        movies.append(Movie(name: "Spider-Man:Across the Spider-Verse", imdb: 0.0, imageAddress: "spiderman", desc: "Miles Morales catapults across the Multiverse, where he encounters a team of Spider-People charged with protecting its very existence. When the heroes clash on how to handle a new threat, Miles must redefine what it means to be a hero.", year: 2023))

        tableView.reloadData()
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
