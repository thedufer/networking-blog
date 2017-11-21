#!/bin/bash

jekyll build
scp -r _site/* aarondufour.com:~/www/networking/
