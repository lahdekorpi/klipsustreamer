# klipsustreamer
A simple and lightweight CLI tool to monitor clipboard changes and output the contents as a JSON stream, intended to be called by external applications to monitor clipboard events.

As there is no way to listen to clipboard events it uses a polling method. But instead of reading the clipboard contents continuously, it will look for the `changeCount` number provided by `NSPasteboard`. It is a counter that increases every time the clipboard contents change. Therefore the implementation is lightweight and consumes minimal amounts of memory and CPU, even with fast polling times.

## Installation
### Option 1
Download the binary from https://github.com/lahdekorpi/klipsustreamer/releases and run the `klipsustreamer` executable.
### Option 2
Download or clone the sources and open the project with Xcode, then build.
### Option 3
Run:  
`sudo wget https://github.com/lahdekorpi/klipsustreamer/releases/download/v1.0.0/klipsustreamer -O /usr/local/bin/klipsustreamer && chmod a+rx /usr/local/bin/klipsustreamer`
_Make sure you have /usr/local/bin in your $PATH_

## Usage
klipsustreamer is a command line application intended to be called from another application that reads its JSON output, instead of having to implement a `pbpaste` or other implementation.  
When you start `klipsustreamer` it will output to stdout a JSON object with the current clipboard contents and a new line (`\n`), as is every time the clipboard content changes (NSPasteboard changeCount).

The JSON contains the data in UTF-8 as `data` and the type of the data available from the pasteboard in `type` as a string, in prioritized order: html, rtf or text. Meaning, if HTML and RTF are available, HTML is outputted.

### Options
As there is currently no known way of listening to clipboard events reliably, a polling method is used instead.  
You can change the polling interval with `-i <seconds>`. It defaults to 0.1. 
By default it's enough to just bundle and call `klipsustreamer` and parse for every `\n` found.

### Output examples:
**Text:** `{"type":"text","data":"Hello World!"}`  
**HTML:** `{"type":"html","data":"<meta charset='utf-8'><span style=\"color: rgb(0, 0, 0); font-family: &quot;helvetica neue&quot;; font-size: medium; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: normal; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">Hello World!<\/span>"}`
**RTF:** `{"type":"rtf","data":"{\\rtf1\\ansi\\ansicpg1252\\cocoartf1504\\cocoasubrtf830\n{\\fonttbl\\f0\\fswiss\\fcharset0 Helvetica;}\n{\\colortbl;\\red255\\green255\\blue255;}\n{\\*\\expandedcolortbl;;}\n\\pard\\tx566\\tx1133\\tx1700\\tx2267\\tx2834\\tx3401\\tx3968\\tx4535\\tx5102\\tx5669\\tx6236\\tx6803\\pardirnatural\\partightenfactor0\n\n\\f0\\b\\fs24 \\cf0 Hello World!}"}`  
