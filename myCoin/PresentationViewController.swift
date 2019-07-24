//
//  PresentationViewController.swift
//  myCoin
//
//  Created by Artem Grebenkin on 6/13/19.
//  Copyright © 2019 Artem Grebenkin. All rights reserved.
//

import UIKit

class PresentationViewController: UIViewController {

    @IBOutlet weak var labelPresentation: UILabel!
    @IBOutlet weak var labelEmo: UILabel!
    @IBOutlet weak var indicatorPages: UIPageControl!
    

    var presentationText = ""
    var emoj = ""
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelPresentation.text = presentationText
        labelEmo.text = emoj
        indicatorPages.currentPage = currentPage
    }
    
}
