LuchTimer
=========

LunchTimer is a simple project demonstrating the use of CLCircularRegions and monitoring with MapKit.  It places a region over your current location, starting a timer when you exit and stopping it when you return.

![Screenshot](http://localhost/uploadscreenshotsometime.png "LunchTimer example")

Usage 
----

Compile and run, the only thing to set is a define in the prefix file called LUNCH_RADIUS.

Class Overview
----

#### AppDelegate

Empty, default app delegate.

#### ViewController

This does most of the work and thus completely violates the single responsibility principle. :D  Sets up the map view with some reasonable defaults, including a relatively zoomed in view.  Has an IBAction for a button in the top right that drops a pin on the centre and starts things off.  When the region is left the current NSDate is kept in a property, on each tick of a timer this property is used to calculate the time interval since the region was left.  This is broken down into hh:mm:ss to update the clock on screen.  The CLLocationManager delegate methods are used to keep the map centered and determine when a user enters/exits a region.  Upon entering a region the timer is invalidated, the overlay removed and stored date reset, returning the application to a state where it can be used again.  The UILabel displaying the time however is not reset at this point so you know how much time has passed.

#### LunchAnnotationView

This is a subclass of MKPinAnnotationView and provides the functionality needed to draw a circular overlap on the map.  It also enables drag'n'drop of the pin.  Used by ViewController.

#### LunchAnnotation 

Simple annotation, has a title and a subtitle set to the latitude, longitude and radius of the pin.  Used by LunchAnnotationView and ViewController.

To Do
----

Neaten up code, turn project into tiny example of Single Responsibility Principle.

