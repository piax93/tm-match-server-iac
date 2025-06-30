#!/bin/bash

php configs/server.xml.php > configs/server.xml

exec php ManiaControl.php
