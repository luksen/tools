#!/bin/bash

pandoc -f markdown -t latex -o ${1%.*}.pdf $1
