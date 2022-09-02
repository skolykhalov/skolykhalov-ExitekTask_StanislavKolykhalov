//
//  ViewController.swift
//  ExitekTask_StanislavKolykhalov
//
//  Created by Stas on 31.08.2022.
//

import UIKit
import OrderedCollections

class ViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var movieArray = OrderedSet<MovieData>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        yearTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadMovies()
    }
    
    private func loadMovies() {
        
        movieArray = DataManager.shared.loadMovie()
    }
    
    //MARK: - AddButton Functions
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        let newMovie = MovieData()
        newMovie.movieTitle = titleTextField.text ?? ""
        newMovie.movieDate = Int(yearTextField.text ?? "") ?? 0
        
        DataManager.shared.saveMovie(movie: newMovie)
        
        if !movieArray.contains(newMovie) {
            movieArray.append(newMovie)
            tableView.insertRows(at: [IndexPath(row: movieArray.count-1, section: 0)], with: .automatic)
            
        } else if let index = movieArray.firstIndex(of: newMovie) {
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
        
        titleTextField.endEditing(true)
        yearTextField.endEditing(true)
        titleTextField.text = ""
        yearTextField.text = ""
        
    }
  
}

//MARK: - TableView DataSource

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let title = movieArray[indexPath.row].movieTitle
        let date = movieArray[indexPath.row].movieDate
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
            
            let movieToDelete = movieArray[indexPath.row]
            DataManager.shared.deleteMovie(movie: movieToDelete)
            movieArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
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
