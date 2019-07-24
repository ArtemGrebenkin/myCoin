//
//  PresentationPageViewController.swift
//  myCoin
//
//  Created by Artem Grebenkin on 6/13/19.
//  Copyright © 2019 Artem Grebenkin. All rights reserved.
//

import UIKit

class PresentationPageViewController: UIPageViewController {

    /*
     let arrayPresentationText = ["Привет! Вы когда-нибудь задумывались сколько монет вы нашли под ногами? Сколько денег упало вам с неба! Это приложение поможет вам посчитать каждую найденую копейку!  Если вы поднимите и согреете одинокую маленькую монетку то однажды большие деньги придут согреть вас" ,
     "Каждая найденная монета будет показана на карте там где вы ее нашли и вы всегда будете знать где и сколько их...",
     "И помните! Даже одна маленькая монетка имеет силу больших денег!"]
     */
    let arrayPresentationText = ["Hello! Have you ever wondered how many coins you found under your feet? How much money fell from the sky! This application will help you count every penny! If you pick up and warm a lonely little coin, one day big money will come to warm you!",
        "Each found coin is shown on the map and you will always know where and how much you earn!",
        "And remember! Even one small coin has the Power of big money!"]
    
    let arrayEmoj = ["🙂", "👌", "☝️"]
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        if let presentationViewController = showPresentationAt(0) {
            setViewControllers([presentationViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    
    func showPresentationAt(_ index: Int) -> PresentationViewController? {
        guard index >= 0 else {return nil}
        
        guard index < arrayPresentationText.count else {
            dismiss(animated: true, completion: nil)
            UserDefaults.standard.set(true, forKey: "Presentation was showed")
            //UserDefaults.standard.synchronize()
            return nil
        }
        
        guard let presentationVC = storyboard?.instantiateViewController(withIdentifier: "presentationViewController") as? PresentationViewController else {return nil}
        presentationVC.presentationText = arrayPresentationText[index]
        presentationVC.emoj = arrayEmoj[index]
        presentationVC.currentPage = index
        return presentationVC
    }


}



extension PresentationPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var pageNumber = (viewController as! PresentationViewController).currentPage
        pageNumber -= 1
        return showPresentationAt(pageNumber)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var pageNumber = (viewController as! PresentationViewController).currentPage
        pageNumber += 1
        return showPresentationAt(pageNumber)
    }
    

  
}
