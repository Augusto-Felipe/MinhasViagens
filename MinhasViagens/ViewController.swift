//
//  ViewController.swift
//  MinhasViagens
//
//  Created by Felipe Augusto Correia on 05/02/23.
//

import UIKit

class ViewController: UITableViewController {

    
    @IBOutlet var tableview: UITableView!
    
    var locaisViagens: [Dictionary<String, String>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableview.delegate = self
        tableview.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(adicionarLocal))

    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadTableview()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locaisViagens.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celula = tableView.dequeueReusableCell(withIdentifier: "celulaDeReuso")!
        celula.textLabel?.text = locaisViagens[indexPath.row]["local"]
        return celula
    }
    
    @objc func adicionarLocal() {
        performSegue(withIdentifier: "toMapVC", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            ArmazenamentoDeDados().removerViagem(indice: indexPath.row)
            reloadTableview()
        }
    }
    
    func reloadTableview() {
        locaisViagens = ArmazenamentoDeDados().listarViagens()
        tableview.reloadData()
    }
    
}

