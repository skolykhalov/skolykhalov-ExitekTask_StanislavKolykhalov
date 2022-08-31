//
//  ViewController.swift
//  ExitekTask_StanislavKolykhalov
//
//  Created by Stas on 31.08.2022.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    
    var movieArray: Results<MovieData>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        yearTextField.delegate = self
        
        movieArray = DataManager.shared.loadMovie()

    }
    
    //MARK: - AddButton Functions
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        let newMovie = MovieData()
        newMovie.movieTitle = titleTextField.text ?? ""
        newMovie.movieDate = Int(yearTextField.text ?? "") ?? 0
     
        DataManager.shared.saveMovie(movie: newMovie)
        tableView.reloadData()
        
        titleTextField.endEditing(true)
        yearTextField.endEditing(true)
        titleTextField.text = ""
        yearTextField.text = ""
    }
  
}

//MARK: - TableView DataSource

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let title = movieArray?[indexPath.row].movieTitle ?? "No movies added"
        let date = movieArray?[indexPath.row].movieDate ?? 0
        cell.textLabel?.text = title + " " + String(date)
        return cell
    }
}

//MARK: - TableView Delegate

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            guard let movieToDelete = movieArray?[indexPath.row] else { return }
            DataManager.shared.deleteMovie(movie: movieToDelete)

            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}

//MARK: - TextField Delegate

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        titleTextField.endEditing(true)
        yearTextField.endEditing(true)

        return true
    }
    
}
