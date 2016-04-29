# SensorDataAcquisition
Built to stream and capture data from all sensors for research purposes.

## Dependencies

Uses the Microsoft Band Kit (MSB) for iOS (included). You can get the latest version from: http://developer.microsoftband.com/
Demonstrates use of MSB with Swift. Written with Swift 2.0 and Xcode 7.3.

Requires a Microsoft Band paired with your iPhone (there is no simulator, you need a physical band).

##Using

Download, build and run.

## Authors

Eric Meadows, https://www.entrygue.com/

## About the Code

This is a straight port. The only real difference is the use of a dispatch_async with block instead of using performSelector to handle the sensor unsubscribe after 60 seconds.
# entrygueMigraine
