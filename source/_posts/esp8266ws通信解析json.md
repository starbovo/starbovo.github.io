---
title: esp8266websocket通信解析json数据包
date: 2023/9/15
tags:
  - esp8266
categories: 物联网项目
description: 第一次接触ws这种协议，记录一下
cover: 'https://pic3.zhimg.com/80/v2-170754f52dd6a5722a4007d89ce50f41_qhd.jpg'
abbrlink: d4f17667
---

## 写在前面

此项目是构建一个esp8266客户端，连接远程服务器以ws通信，数据格式是json。

## 所需arduino库

我使用的是ArduinoWebsockets库，亲测在nodemcu上可以使用。

## 代码实现

```c
#include <ArduinoJson.h>
#include <ArduinoWebsockets.h>
#include <ESP8266WiFi.h>

const char* ssid = " "; //Enter SSID
const char* password = " "; //Enter Password
const char* websockets_server_host = " "; //Enter server adress
const uint16_t websockets_server_port = 8080; // Enter server port

using namespace websockets;

void onMessageCallback(WebsocketsMessage message) {
    Serial.print("Got Message: ");
    Serial.println(message.data());
    // 解析JSON消息
    DynamicJsonDocument jsonDoc(256);
    DeserializationError error = deserializeJson(jsonDoc, message.data());
    
    if (error) {
      Serial.print("JSON parsing failed: ");
      Serial.println(error.c_str());
      return;
    }
    
    // 提取JSON字段值
    int messageType = jsonDoc["type"];
    String data = jsonDoc["data"];
    
    // 在这里根据消息类型执行相应的操作
    switch (messageType) {
      case 1000:
        Serial.println("Received message type 1000");
        // 在这里执行处理消息类型1000的代码
        // data 变量包含了密钥信息
        break;
      case 1001:
        Serial.println("Received message type 1001");
        break;
      default:
        Serial.println("Unknown message type");
        break;
    }

}

void onEventsCallback(WebsocketsEvent event, String data) {
    if(event == WebsocketsEvent::ConnectionOpened) {
        Serial.println("Connnection Opened");
    } else if(event == WebsocketsEvent::ConnectionClosed) {
        Serial.println("Connnection Closed");
    } else if(event == WebsocketsEvent::GotPing) {
        Serial.println("Got a Ping!");
    } else if(event == WebsocketsEvent::GotPong) {
        Serial.println("Got a Pong!");
    }
}

WebsocketsClient client;
void SendJSON(DynamicJsonDocument jsonDoc)
{
  String jsonStr;
  bool ifsuccess=false;
  serializeJson(jsonDoc, jsonStr);
  ifsuccess = client.send(jsonStr);
  Serial.println(jsonStr);
  //Serial.println(ifsuccess);
}
void setup() {
    Serial.begin(115200);
    // Connect to wifi
    WiFi.begin(ssid, password);

    // Wait some time to connect to wifi
    for(int i = 0; i < 10 && WiFi.status() != WL_CONNECTED; i++) {
        Serial.print(".");
        delay(1000);
    }
    Serial.println("WIFI has connected!");
    // run callback when messages are received
    client.onMessage(onMessageCallback);
    
    // run callback when events are occuring
    client.onEvent(onEventsCallback);

    // Connect to server
    client.connect(websockets_server_host, websockets_server_port, "/");

    DynamicJsonDocument jsonDoc(256);
    jsonDoc["type"] = 1000;
    jsonDoc["data"] = "secretkey";
    SendJSON(jsonDoc);

    // Send a ping
    client.ping();
}

void loop() {
    client.poll();
    DynamicJsonDocument jsonDoc(256);
    jsonDoc["type"] = 1001;
    jsonDoc["data"] = "secretkey";
    SendJSON(jsonDoc);
    delay(10000);
}
```

