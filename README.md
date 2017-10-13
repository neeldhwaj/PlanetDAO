# PlanetDAO

## Overview

In this project we aim to create a DAO using Ethereum Blockchain on the basis of colony.io's whitepaper. The idea is to learn implementation of DAO in ethereum and understand usage of following concepts -

* ERC20 token standards
* Voting mechanism
* Reputation System

## Quickstart
TBA

## Debugging

```
$ truffle console
truffle(development)> compile
truffle(development)> dao.new('Owner name')
```
If getOwner is a constant function, you will get the output immediately on the console
```
truffle(development)> dao.at("contract address").getOwner()   
```
if getOwner is not a constant function, use events (say Owner is an event).
```
truffle(development)> dao.at('contract address').getOwner()
truffle(development)> dao.at('contract address').Owner(function (e, result) { if (!e) {console.log(result)}})
```
Note: Don't forget to add any new contracts to the migration file.

## Contribution

We welcome contributions to this project, please feel free to raise PRs or Issues.

Fork -> Edit -> Submit pull requests.
