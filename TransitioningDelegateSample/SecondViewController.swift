//
//  SecondViewController.swift
//  TransitioningDelegateSample
//
//  Created by Kentaro Matsumae on 2017/10/04.
//  Copyright © 2017年 DeNA. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func didPan(_ sender: UIPanGestureRecognizer) {
        print(#function)
        
        let vc = presentingViewController as! ViewController
        let del = self.transitioningDelegate as! MyTransitionDelegate
        del.sourceViewDidPan(recognizer: sender, sourceVC: vc)
    }
    
    @IBAction func closeDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
