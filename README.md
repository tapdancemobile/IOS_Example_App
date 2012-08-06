Introduction
=========================

This is a simple application really just intended to be a code example, but it could be useful to anyone looking for hints on integrating RestKit into a real-world application.

Design
-------------------------
I typically will code a: **View**, **View Controller**, **Business Object**, and some type of **Model**. I tend to use RestKit to handle the interaction between my **Business** objects and **Model**.

This App Features
-------------------------
1. **White Label** - This app supports creating multiple branded app targets from a single x-code project. This includes the icon, splash screen, logo, color scheme, and webservice authentication info.
2. **CI Build** - This app supports testing from a Jenkins server for each branded target
3. **Pull To Refresh** - This app has a pull to refresh feature
4. **Ajax-like Search Bar** - This app has a search bar used to instantly filter the list
5. **Custom Swipe Action** - This app has a custom swipe gesture recognizer that allows for the item in the list to have actions executed against it.

To Run...
-------------------------
I have a sinatra ruby script in the test directory to help with my unit tests. You will have to use this if you want to see data returned. Just navigate to the directory that server.rb is located and execute 'ruby server.rb'.
You may need to install ruby and or sinatra to get it to work...
