![Screenshot](SCREENSHOT.jpg)

# Bee-Up via Docker

[![license](https://img.shields.io/github/license/realk1ko/beeup-docker.svg)](https://github.com/realk1ko/beeup-docker/blob/master/LICENSE)

> Bee-Up is an ADOxx-based hybrid modelling tool, encompassing five different modelling languages:
> * BPMN - Business Process Model and Notation
> * EPC - Event-driven Process Chains
> * ER - Entity Relationship Diagrams
> * UML - Unified Modeling Language
> * Petri Nets

_&#8213; https://bee-up.omilab.org/activities/bee-up/_

## Intro
This repository serves as an alternative installation approach for Bee-Up. Whenever you need to use Bee-Up you can 
simply open your browser and visit `http://localhost:8080/vnc.html`.

## Installation
1) Clone this repository
2) 
   1) Linux/Mac OS: Open a terminal and run `bash install.sh` in the repository root
   2) Windows: Open a PowerShell and run `install.ps1` in the repository root
3) Follow the instructions in the terminal
4) Refer to [Notes on Usage](#notes-on-usage)  for post installation tips

## Uninstallation
1) 
   1) Linux/Mac OS: Open a terminal and run `bash uninstall.sh` in the repository root
   2) Windows: Open a PowerShell and run `uninstall.ps1` in the repository root

## Notes on Usage
- Turn on remote resizing for the best user experience. Click on the gear icon (options) on the left hand side and
  change the scaling mode.
- The bundled standard attribute profiles (`*.adl`) can be found in the home directory of the user inside the container.
- The installation script sets up a directory within the repository root (`./pdfs`) into which the PDF printed models
  are exported.
- This was last tested with the Bee-Up 1.6 release for macOS (`sha1sum: 7e323785a46c0a438144abf1b19cb19d43d64fea`)
  on Fedora 34 64-bit and MacOS 12.2.1 M1.
