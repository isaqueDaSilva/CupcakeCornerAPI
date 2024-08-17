# Table of Contents
1. [Overview](#overview)
2. [Features](#features)
3. [Getting started](#getting-started)
4. [Usage](#usage)
5. [Requirements](#requirements)
6. [Workflow](#workflow)

# Cupcake Corner API
 The system that powered all external features in the Cupcake Corner app.
 
 # Overview
This RESTful API powers all external resources like communicating with the Postgres database for make some CRUD oparation, comunicate with administrator informing him when a new order is requested by Web Socket and even makes the User Authentication/Authorization with JWT tokens.<br>
This API, also building using Swift with Vapor framework.

# Features
* Comunication with Postgres Database for makes some CRUD operation;<br>
* Authentication and Authorization with JWT;<br>
* WebSocket for makes bidirectional communication between client side and server side for real time information;<br>

# Getting started
1. Make sure you have the Xcode version 15.4 or above installed on your computer.<br>
2. Downloads the Cupcake Corner project file from this repositorys. <br>
3. Make sure that you have some Postgres database service for utilize in this project. If no you can get some free service, like [Neon](https://neon.tech), as that I'm using now.
4. Open the project files in Xcode.<br>
5. Select the current schema and them Edit Schema>Run.
6. Add two arguments in Arguments Passed on Launch: 
```
1° -> migrate
2° -> migrate --revert
```
7. Add more six enviroments variables in the same location:
```
JWT_SECRET = {Your JWT secret}
CUPCAKE_CORNER_JWTSUB = {Your subject claim for JWT}
ADMIN_NAME = {Some name for default admin}
ADMIN_EMAIL = {Some email for default admin}
ADMIN_PASSWORD = {Some password for default admin}
DATABASE_KEY = {Your API key}
```
8. Review the code and make sure you understand what it does.<br>
9. Run the server with the `migrate` flag active.<br>
10. After the migration will be finish with success, disable the previous flag
11. Finally, runs the server. 

# Usage
- Run this server, and them runs the client and admin versions Cupcake Corner app, and test the routes there.;

# Requirements
- Xcode 15.4+

# Workflow
* Reporting bugs:<br> 
If you come across any issues while using the Cupcake Corner, please report them by creating a new issue on the GitHub repository.

* Reporting bugs form: <br> 
```
App version: 1.0
macOS version: 14.6.1
Xcode version: 15.4
Description: When I'm access the BagView in the CupcakeCorner app in both admin and client versions, the server crashes.
```

* Submitting pull requests: <br> 
If you have a bug fix or a new feature you'd like to add, please submit a pull request. Before submitting a pull request, 
please make sure that your changes are well-tested and that your code adheres to the Swift style guide.

* Improving documentation: <br> 
If you notice any errors or areas of improvement in the documentation, feel free to submit a pull request with your changes.

* Providing feedback:<br> 
If you have any feedback or suggestions for the Cupcake Corner project, please let us know by creating a new issue.
