SensorMonkeySerialNet
=====================

A serial-to-network proxy for relaying data between a serial port and a TCP/IP socket connection.
Allows an [Arduino](http://arduino.cc/) (or other sensor) to connect to [SensorMonkey](http://sensormonkey.com/).
Serves [Flash Socket Policy](http://www.adobe.com/devnet/flashplayer/articles/socket_policy_files.html) files inline on the specified port.

Built for [Processing](http://processing.org/).

Installation
------------

Clone the repo using [Git](http://git-scm.com/) or download the source code as a zip or tarball.

Running
-------

Open the file SensorMonkeySerialNet.pde with [Processing](http://processing.org/) and click **Run**.

Configuration
-------------

You can edit the following global variables in the sketch to suit your needs:

* `port` The TCP/IP port on which to listen for incoming network connections (default is 20000)
* `pollingFreq` The polling frequency (in Hz) of the sketch (default is 50)
* `baudRate` The baud rate to use for serial communication (default is 9600)
* `policyFile` The [Flash Socket Policy](http://www.adobe.com/devnet/flashplayer/articles/socket_policy_files.html) file to serve inline
* `waitTime` Time (in milliseconds) to wait after a new client connects before continuing to transfer data from the serial port to the open TCP/IP socket connection(s) (default is 1000)

**Important!** The sketch will attempt to open the first serial port in the list of serial ports
so change the array index to match your sensor if needed (see `setup()` function).

Known Issues
------------

* You should only attempt to connect a single client to the server at any one time. Otherwise, the Flash Socket Policy file will be sent to all currently connected clients every time a new one connects.
* When connecting and disconnecting a client, the server may generate a `java.net.SocketException: Broken pipe` or a `java.net.SocketException: Software caused connection abort: socket write error` error. These can be safely ignored.
* There are known issues with Processing and Bluetooth virtual serial ports when running under Windows. If you're on a Windows machine, download and install [Bloom](http://sensormonkey.com/index.php/site/page?view=support.bloom) instead of running this sketch (whether you're using Bluetooth or not). Your sanity will thank you for it!
* When terminating the sketch, use the **Stop** button on the Processing IDE rather than the Close button on the sketch's display window.
* If you get a "WARNING: RXTX Version mismatch" error when running the sketch you can (in my experience) usually safely ignore it. However, if you want to update the serial library to avoid the error in the future, please see the [threads](http://forum.processing.org/search/rxtx) in the Processing forums.
* If you're having trouble getting the sketch to run on Linux, the cause may be a bug in Processing that denies communication to the serial port because of the name it uses in the /dev/ folder. Please see the final post in [this](http://forum.processing.org/topic/error-message-about-serial-library-version) thread that describes how to solve this issue.

More Information
----------------

* Visit [SensorMonkey](http://sensormonkey.com/) on the Web
* [Google Group](https://groups.google.com/group/sensor-monkeys) for discussion
* Follow [sensormonkey](https://twitter.com/sensormonkey) on Twitter for updates
* Visit [SensorMonkey](https://www.facebook.com/pages/Sensormonkeycom/342578152478356) on Facebook
* [SensorMonkey](https://github.com/sensormonkey) on GitHub
