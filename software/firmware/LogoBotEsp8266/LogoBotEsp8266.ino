#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <EEPROM.h>
 
ESP8266WebServer server(80);
const int led = 2;

void handleRoot() {
  digitalWrite(led, 1);

  String page = "<!DOCTYPE html>";
  page += "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">";
  page += "<html>";
  page += "<head><title>Logobot Blue</title></head>";
  page += "<body style=\"font-size: 24px;\">";
  
  page += "Distance: <input type=\"text\" id=\"dist\" value=\"1000\" /><br />";
  page += "<a href=\"#\" onclick=\"l('BK', document.getElementById('dist').value);\">Backward</a> : ";
  page += "<a href=\"#\" onclick=\"l('FD', document.getElementById('dist').value);\">Forward</a><br/>";

  page += "<hr/>";

  page += "Angle: <input type=\"text\" id=\"angle\" value=\"90\" /><br />";
  page += "<a href=\"#\" onclick=\"l('LT', document.getElementById('angle').value);\">Left</a>: ";
  page += "<a href=\"#\" onclick=\"l('RT', document.getElementById('angle').value);\">Right</a><br/>";

  page += "<hr />";
  
  page += "<button onclick=\"l('PU', null);\">Pen Up</button>";
  page += "<button onclick=\"l('PD', null);\">Pen Down</button>";

  page += "<hr />";
  
  page += "<button onclick=\"l('ST', null);\">Stop</button>";
  page += "<button onclick=\"l('BZ', 500);\">Horn</button>";
  
  page += "<hr/>";
  
  page += "<div><span id=\"lastCmd\"></span>:<span id=\"lastResp\"</span></div>";
  
  page += "<script type=\"text/javascript\">";
  page += "    function l(cmd, dist) {";
  page += "        var xhReq = new XMLHttpRequest();";
  page += "        var uri = '/cmd?action=' + cmd;";
  page += "        if (dist) { uri += '&dist=' + dist; }";
  page += "        xhReq.open('GET', uri, true);";
  page += "        xhReq.send();";
  page += "        xhReq.onload = function () {";
  page += "          document.getElementById('lastCmd').innerText = cmd + ' ' + dist;";
  page += "          document.getElementById('lastResp').innerText = this.responseText;";
  page += "        }";
  page += "    };";
  page += "</script>";

  page += "</body>";
  page += "</html>";
  
  server.send(200, "text/html", page);
  digitalWrite(led, 0);
}

void handleCommand()
{
  digitalWrite(led, 1);
  
  if (server.hasArg("action") && server.hasArg("dist"))
    Serial.println(server.arg("action") + " " + server.arg("dist"));
  else if (server.hasArg("action"))
    Serial.println(server.arg("action")); 
  
  server.send(200, "text/plain", "ok");
  
  digitalWrite(led, 0);
}

void handleNotFound(){
  digitalWrite(led, 1);
  String message = "File Not Found\n\n";
  message += "URI: ";
  message += server.uri();
  message += "\nMethod: ";
  message += (server.method() == HTTP_GET)?"GET":"POST";
  message += "\nArguments: ";
  message += server.args();
  message += "\n";
  for (uint8_t i=0; i<server.args(); i++){
    message += " " + server.argName(i) + ": " + server.arg(i) + "\n";
  }
  server.send(404, "text/plain", message);
  digitalWrite(led, 0);
}
 
void setup(void){
  Serial.begin(9600);
  Serial.println();
  Serial.println("Logobot Wifi Interface");
  
  pinMode(led, OUTPUT);
  digitalWrite(led, 0);

  WiFi.softAP("LogobotBlue", "logobot1");
  WiFi.mode(WIFI_AP);
  
  server.on("/", handleRoot);
  server.on("/cmd", handleCommand);
  server.onNotFound(handleNotFound);
  
  server.begin();
}
 
void loop(void){
  server.handleClient();
}
