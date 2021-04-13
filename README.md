# piopener-app

### What is it?

Our project, titled piopener, is the infrastructure designed to allow us to communicate with our garage door via our API and perform actions upon it. These actions can be opening, closing, checking history, checking current open status, etc.

#### Repositories of piopener

- [piopener-server](https://github.com/joeylemon/piopener-server): Node.js backend
- [piopener-pi](https://github.com/joeylemon/piopener-pi): Raspberry Pi & Node.js client
- [piopener-app](https://github.com/joeylemon/piopener-app): Swift & storyboards iOS frontend

### Why?

After continuously losing, forgetting, or otherwise destroying our garage door openers, my roommate and I decided it would be a fun idea to reverse-engineer our garage door and allow us to do whatever we wanted with it.

### How?

We soldered two wires from the Raspberry Pi to the circuit board inside of one of our garage door openers, allowing us to send a signal programatically to the door opener. This allows us to set up the endpoint for opening and closing the garage door. In order to check of the status of the door (opened or closed), we wired one magnetic reed switch to the Pi and one to the garage door, allowing us to check if the door is closed if the switches are connected.

### What is piopener-app?

This repository is the iOS application which serves as an interface to the [piopener-server](https://github.com/joeylemon/piopener-server). The application provides the means to open and close the door manually, as well as automatically by tracking the user's location and opening the garage door when nearing the home location. The app integrates with Siri to allow users to open or close the garage with a voice command. It also lists the history of the garage door's openings and closings.

#### Technologies:
- Swift: this app was created natively for iOS using Swift and storyboards
- SiriKit: users can ask Siri to open or close the garage by, for example, saying "Hey Siri, open the garage"

<br>
<img src="https://i.imgur.com/WqypmH1.png" width="700">
