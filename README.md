# Monster Shop - Turing Back End Engineering, Module 2, Group Project
### Heroku Link
https://monster-shop-dreamteam.herokuapp.com/

### Schema Design
https://dbdiagram.io/d/5e4c68d49e76504e0ef19d9d

### Contributors
[Jordan Williams](https://github.com/iEv0lv3)

[David Atkins](https://github.com/d-atkins)

[Kathleen Carroll](https://github.com/kathleen-carroll)

[Raymond Nguyen](https://github.com/itemniner)

### Overview:
Monster Shop is an ecommerce website that allows you to browse through merchants and their items. This website allows admin, merchant, user and visitor access.

A visitor can visit the site to browse shops and their items. Items can be added to the cart. A visitor must login or register to checkout.

A regular user has a profile displaying their information, which is saved in the database. This information can be edited at any time. Users have access to checkout items from the cart, view orders, or continue shopping.

A merchant employee has access to the merchant dashboard which gives access to fulfill orders, create items, delete items, and view orders placed for items sold by the merchant.

An administrator has access to the admin dashboard, which allows for CRUD functionality across all items, merchants, and users.

BE Mod 2 Week 4/5 Group Project

### Getting Started
1. Fork this repository
2. Clone down your forked repository
3. From your repository's root directory, run:
`bundle install`
4. Set up the database
`rake db:{drop,create,migrate,seed}`

### Merchants
![merchant index](https://files.slack.com/files-pri/T029P2S9M-FUP6YNHAB/screen_shot_2020-02-27_at_8.11.02_pm.png)
![merchant show](https://files.slack.com/files-pri/T029P2S9M-FUMB1PUQ0/screen_shot_2020-02-27_at_8.11.51_pm.png)
Merchants are stores that carry items.
- index shows all merchants
- show page shows information for a single merchant
- can be activated/deactivated by administrator

### Items
![item index](https://files.slack.com/files-pri/T029P2S9M-FULT4DJ3W/screen_shot_2020-02-27_at_8.13.09_pm.png)
![item show](https://files.slack.com/files-pri/T029P2S9M-FU8H9F5PC/screen_shot_2020-02-27_at_8.12.35_pm.png)
Items belong to merchants, and can be added to the cart.
- items can be deactivated by merchant employees and admins
  - deactivated items will not show up in the items index
- items have inventory which limit how many a user can add to the cart

### Users
1. Visitor - this type of user is anonymously browsing our site and is not logged in. Permissions for visitors:
  - access to merchants and items with ability to add items to cart.  Visitor must log in to checkout.
  - can not access any pages outside of merchant and item shopping sites
  - no profile information
2. Regular User - this user is registered and logged in to the application while performing their work; can place items in a cart and create an order. Permissions for regular user:
  - same access as visitor
  - can edit profile information, can update password information, can place orders and cancel orders
3. Merchant Employee - this user works for a merchant. They can fulfill orders on behalf of their merchant. They also have the same permissions as a regular user (adding items to a cart and checking out). Permissions for merchant employees:
  - Merchants can fulfill orders
  - Add, edit, delete, and update items
  - Update merchant store information
  - Place orders
4. Admin User - a registered user who has "superuser" access to all areas of the application; user is logged in to perform their work
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
