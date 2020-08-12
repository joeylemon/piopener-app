# piopener-app

### What is it?

Our project, titled piopener, is the infrastructure designed to allow us to communicate with our garage door via our API and perform actions upon it. These actions can be opening, closing, checking history, checking current open status, etc.

### Why?

After continuously losing, forgetting, or otherwise destroying our garage door openers, my roommate and I decided it would be a fun idea to reverse-engineer our garage door and allow us to do whatever we wanted with it.

### How?

During the aforementioned destruction of a garage door opener, I noticed the circuit board inside was extremely simple: a single battery and two buttons with lots of space for soldering. So, after investing in a soldering iron, we went to work on attempting to wire up a circuit between the Raspberry Pi and the opener circuit. A very short amount of time later (or maybe a few hours since we've never soldered before), we had a working circuit in which we could send a signal from the Raspberry Pi to the garage door opener to open the garage.

This only solved how to open the garage door programatically, we still needed a way to see if the door was currently open or closed. We decided to buy a few magnetic reed switches and mount them on the garage door and its frame. So, when the door opens, the circuit closes and we know the door is open.

### What is piopener-app?

This repository is the iOS application which serves as an interface to the [piopener-server](https://github.com/joeylemon/piopener-server), which hosts the API and performs the actual opening and closing of the garage door using the circuit board.

The application provides the means to open and close the door manually, as well as automatically by tracking the user's location and opening the garage door when nearing the home location. It also lists the history of the garage door's openings and closings.

#### Technologies:
- Swift: this app was created natively for iOS using Swift and storyboards

<br>
<img src="https://i.imgur.com/kqOjIQS.png" width="400">
