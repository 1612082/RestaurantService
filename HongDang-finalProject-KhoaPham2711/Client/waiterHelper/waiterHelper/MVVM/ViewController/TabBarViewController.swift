//
//  TabBarViewController.swift
//  waiterHelper
//
//  Created by HongDang on 2/20/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabbar()
    }
    
    func setupTabbar(){
            
            // xac dinh man hinh
            let Lobby = Main_Storyboard.instantiateViewController(withIdentifier: "LobbyViewController") as! LobbyViewController
            Lobby.tabBarItem = UITabBarItem(title: "Lobby", image: #imageLiteral(resourceName: "home"), tag: 1000)
            let NaviHome = NaviViewController(rootViewController: Lobby)
            
            let Order = Kitchen_Storyboard.instantiateViewController(withIdentifier: "KitchenViewController") as! KitchenViewController
            Order.tabBarItem = UITabBarItem(title: "Order", image: #imageLiteral(resourceName: "order"), tag: 1000)
            let NaviOrder = NaviViewController(rootViewController: Order)
            
            let Payment = Payment_Storyboard.instantiateViewController(identifier: "PaymentViewController") as! PaymentViewController
            Payment.tabBarItem = UITabBarItem(title: "Bill", image: #imageLiteral(resourceName: "pay"), tag: 3000)
            let NaviPayment = NaviViewController(rootViewController: Payment)
            
            let Reservation = Resevation_Storyboard.instantiateViewController(withIdentifier: "ResevationViewController") as! ResevationViewController
            Reservation.tabBarItem = UITabBarItem(title: "Reserved", image: #imageLiteral(resourceName: "reserved"), tag: 1000)
            let NaviReservation = NaviViewController(rootViewController: Reservation)

            
            // dua vao mang tabbar
            self.viewControllers = [NaviHome, NaviOrder, NaviPayment, NaviReservation ]
            
        }


}
