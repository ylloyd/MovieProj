//
//  ViewController.swift
//  MovieProj
//
//  Created by Yvan Elessa on 14/03/2018.
//  Copyright © 2018 Yvan Elessa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emptyTableViewText: UILabel!
    @IBAction func open(_ sender: Any) {
        performSegue(withIdentifier: "nextView", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        emptyTableViewText.text = "You have no movies yet. We suggest you to start by searching a movie"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

