# spay Application

This iOS Application display a list of Beers retrieved from punkapi.com. 

## Versions

There are two branches, you can use the latest commit on master branch to get the latest stable version of the code. 
All the pods have been pushed to the repository, so you don't need do download them. For a list of all the pods used, see the section below.

### Prerequisites

This project has been created using XCode 10.3 and Swift 5.

## Organization of the Project

The main target is spay, which is structured in the following way:
* Beers Page: contains all the files created for the the Beers Page which are organized in sub-folders by the purpose of each file;
* Dependency Injection: this folder contains all the service that are going to be injected when needed and also their implemntation used for the tests;
* Network Manage: here is contained the implementation of the Network Manager;
* Utilities: this folder contains some useful classes used by the application such as the Logger and Extensions.

Inside the project you will find also two test target. The Unit Test target is named spayTests while the UI Test target is named spayUITests.

## Authors

**Nicolò Pasini**
