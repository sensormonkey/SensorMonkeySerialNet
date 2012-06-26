/**
 * SensorMonkey Serial-to-Network Proxy
 * by Aaron McCoy
 *
 * A serial-to-network proxy for relaying data between a serial port
 * and a TCP/IP socket connection. Allows an Arduino (or other sensor)
 * to connect to SensorMonkey. Serves Flash Socket Policy files inline
 * on the specified port.
 *
 * Based on code from:
 *
 * http://arduino.cc/playground/uploads/Interfacing/SerialNet.pde.txt
 *
 * and:
 *
 * http://karoshiethos.com/2010/03/26/serving-a-flash-socket-policy-file-from-processing-org/
 */

import processing.net.*;
import processing.serial.*;

// The TCP/IP port on which to listen for incoming network connections.
int port = 20000;

// The polling frequency (in Hz) of the sketch (should match the sampling rate of your sensor).
int pollingFreq = 50;

// The baud rate to use for serial communication (must match your sensor).
int baudRate = 9600;

// The Flash Socket Policy file to serve inline.
String policyFile = "<?xml version=\"1.0\"?>"
                  + "<!DOCTYPE cross-domain-policy SYSTEM \"/xml/dtds/cross-domain-policy.dtd\">"
                  + "<cross-domain-policy>"
                  + "<site-control permitted-cross-domain-policies=\"master-only\" />"
                  + "<allow-access-from domain=\"*\" to-ports=\"1024-49151\" />"
                  + "</cross-domain-policy>";

// Time (in milliseconds) to wait after a new client connects before continuing
// to transfer data from the serial port to the open TCP/IP socket connection(s).
int waitTime = 1000;

// The current time (in milliseconds) since the sketch was started.
int currentTime = 0;

// Time (in milliseconds) at which the most recent client connected (see serverEvent() function below).
int lastConnectionTime = 0;

Serial serial;
Server server;

void setup() {
  // Print the available serial ports.
  println( Serial.list() );
  
  // Open the first serial port in the list (change to match your sensor if needed).
  serial = new Serial( this, Serial.list()[ 0 ], baudRate );
  
  // Begin listening for incoming network connections on the specified TCP/IP port.
  server = new Server( this, port );
  
  // Set the frame rate to match the polling frequency.
  frameRate( pollingFreq );
}

void draw() {
  // Read from network socket and write to serial port.
  Client client = server.available();
  if( client != null ) {
    byte[] buffer = client.readBytes();
    
    // Is this a Flash Socket Policy file request?
    String message = new String( buffer );
    if( match( message, "<policy-file-request/>" ) != null ) {
      sendPolicyFile( server );
    } else {
      serial.write( buffer );
    }
  }
  
  // Read from serial port and write to network socket.
  currentTime = millis();
  if( currentTime - lastConnectionTime >= waitTime && serial.available() > 0 ) {
    server.write( serial.readBytes() );
  }
}

void sendPolicyFile( Server server ) {
  server.write( policyFile + char( 0 ) );    // Don't forget to null-terminate!
  println( "Sending policy file ..." );
}

// Called when a new client connects to the server.
void serverEvent( Server server, Client client ) {
  lastConnectionTime = millis();
  println( "Accepted new client connection from \"" + client.ip() + "\" ..." );
}

