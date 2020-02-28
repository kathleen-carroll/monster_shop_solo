# Monster Shop - Turing Back End Engineering, Module 2, Group Project
#### Heroku Link
https://monster-shop-dreamteam.herokuapp.com/

#### Contributors
[Jordan Williams](https://github.com/iEv0lv3)

[David Atkins](https://github.com/d-atkins)

[Kathleen Carroll](https://github.com/kathleen-carroll)

[Raymond Nguyen](https://github.com/itemniner)

### Overview:
Monster Shop is fictitious  e-commerce website where users are able to browse items from various shops, add them to their cart, and make orders.

Monster Shop is made up of merchants and items. Merchants have many items, and items belong to merchants. Items can be ordered and reviewed by users. CRUD functionality for merchants, items, and orders is determined by user role: visitor, regular user, merchant employee, and administrator.

### Schema Design
![schema](https://i.imgur.com/srezwoS.png)

### Getting Started
1. Fork this repository
2. Clone down your forked repository
3. From your repository's root directory, run:
`bundle install`
4. Set up the database
`rake db:{drop,create,migrate,seed}`

### Merchants
![merchant index](https://i.imgur.com/oqeYGrW.png)
![merchant show](https://i.imgur.com/d6o4TeS.png)
Merchants are stores that carry items.
- index shows all merchants
- show page shows information for a single merchant
- can be activated/deactivated by administrator

### Items
![item index](https://i.imgur.com/XCwIUx1.png)
![item show](https://i.imgur.com/gI0oCxe.png)
Items belong to merchants, and can be added to the cart.
- items can be deactivated by merchant employees and admins
  - deactivated items will not show up in the items index
- items have inventory which limit how many a user can add to the cart

### Users
Visitor - this type of user is anonymously browsing our site and is not logged in. Permissions for visitors:
  - access to merchants and items with ability to add items to cart.  Visitor must log in to checkout.
  - can not access any pages outside of merchant and item shopping sites
  - no profile information
  
Regular User - this user is registered and logged in to the application while performing their work; can place items in a cart and create an order. Permissions for regular user:
  - same access as visitor
  - can edit profile information, can update password information, can place orders and cancel orders
  
Merchant Employee - this user works for a merchant. They can fulfill orders on behalf of their merchant. They also have the same permissions as a regular user (adding items to a cart and checking out). Permissions for merchant employees:
  - Merchants can fulfill orders
  - Add, edit, delete, and update items
  - Update merchant store information
  - Place orders
  
Admin User - a registered user who has "superuser" access to all areas of the application; user is logged in to perform their work
  - Access to all merchants and ability to disable or enable
  - Access user information
  - Cannot place orders
  - See all orders, ship and cancel orders
  
  ![admin control](https://slack-imgs.com/?c=1&o1=ro&url=https%3A%2F%2Fmedia.giphy.com%2Fmedia%2FQuCiMbc7FWAy2bxWUO%2Fgiphy.gif)
  

### Orders
Orders can be made by regular users and merchant users when items are added to the cart.
Visitors can add items to the cart but must log in to make an order.

Orders have four possible statuses:
- pending: default status
- packaged: all merchants have fulfilled all items on the order
- shipped: admin has approved shipping of order
- canceled: user cancels a pending or packaged order
