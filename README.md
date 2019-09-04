# spay Application

This iOS Application display the list of beers returned by punkapi.com. 

## Getting Started

To get the most updated version of the code, download the last commit in the master branch.

### Prerequisites

This project has been created using XCode 10.3 and Swift 5.

## Organization of the Project

spay is the main target, which is structured in the following way:
* Beers Page: this folder contain all the files related to the page which displays the list of beers. Each file is added to a subfolder organized by the file types (e.g. Views, ViewControllers, Xibs, ...);
* Dependency Injection: is the folder containing the definitions of the services that will be injected, their registration and mock for tests;
* Network Manager: this folder contains the implementation of the Network Manager;
* Utilities: in this folder you can find the Logger class used in the project, some Extensions and the definition of the Errors.

Inside the main target two Test targets are included: spayTest which contains the implementation of the Unit Tests and spayUITest which contains the implementations of different UI Tests.

## Author

**Nicolò Pasini**

