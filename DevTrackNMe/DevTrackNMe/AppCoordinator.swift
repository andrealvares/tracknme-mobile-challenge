//
//  AppCoordinator.swift
//  DevTrackNMe
//
//  Created by Thales Frigo on 24/11/17.
//  Copyright © 2017 Thales Frigo. All rights reserved.
//

import UIKit

class AppCoordinator: CoordinatorType {
    
    let navigationController: UINavigationController
    let firstRunKeeper: FirstRunKeeper
    
    init(navigationController: UINavigationController, firstRunKeeper: FirstRunKeeper) {
        self.navigationController = navigationController
        self.firstRunKeeper = firstRunKeeper
    }
    
    func start(){
        if firstRunKeeper.hasFirstRun {
            startRun()
        } else {
            startOnboarding()
        }
    }
    
    func startOnboarding(){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let onboardingViewController = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
        onboardingViewController.delegate = self
        
        navigationController.pushViewController(onboardingViewController, animated: true)
    }
    
    func startRun(needFirstRun: Bool = false){        
        let runCoordinator = RunCoordinator(navigationController: navigationController,
                                            firstRunKeeper: firstRunKeeper,
                                            needFirstRun: needFirstRun)
        
        runCoordinator.start()
    }
}

extension AppCoordinator: OnboardingViewControllerDelegate {
    func didGiveLocationPermissions(_ onboardingViewController: OnboardingViewController) {
        startRun(needFirstRun: true)
    }
}
