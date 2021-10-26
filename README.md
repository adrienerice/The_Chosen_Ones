# [Click here to see the Exhibit Poster](/Managing%20IM%20Notification%20Disruption/DECO3500_2021_Poster_LukeStringer_43959280.pdf)
# [Click here to see the Web prototype](https://lukestringer.github.io)
# [Click here to see the interim Web prototype](https://lukejoshuastringer.github.io/)

# Structure of this branch:
This folder tree just shows the important files and folders:

Managing IM Notification Disruption/  
├─ is_now_good/  
├─ is_now_good_exhibition/  
├─ is_now_good_interim/  
├─ app-release.apk  
├─ DECO3500_2021_Poster_LukeStringer_43959280.pdf  

* The app-release.apk file is for installing the interim prototype. 
* There are three folders for prototypes. 
  * The first (is_now_good) contains the code for the fully-fledged chat app that I did not finish (see the wiki for more details).
  * The second (is_now_good_exhibition) contains the code for the final prototype shown in the exhibition
  * The third (is_now_good_interim) folder contains code for the prototype that was for the 'lofi' prototype
* Each project folder has a lib/ folder which contains the code for that app.
 
# Prototype Deployment (from the code)  
The interim prototype can be installed on android phones (emulators included) using the .apk file. The final prototype can be view at [lukestringer.github.io](https://lukestringer.github.io).

Otherwise, to deploy any of the prototypes locally from the code: 
* First [install flutter](https://flutter.dev/docs/get-started/install) (https://flutter.dev/docs/get-started/install).  
* Make sure to follow step 3 on the installation page (test drive) so you know how to run a flutter app.  
* Then, download the code, open the folder (one of the is_now_good* ones), and run the flutter app. You can use a browser or a Android or iOS emulator or, through USB debugging, run it on your own phone.   

However, please be aware the app in is_now_good is not fully functional and contains some bugs. It may not run on mobile, as a result of conflicting dependencies required for web.
