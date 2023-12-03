#!/usr/bin/env bash


function main() {

    val=$(download_font "Hack Nerd Font Mono")
    echo "val: $val"

}

function download_font() {
    dato=$1
    echo "$dato-2"
}

main