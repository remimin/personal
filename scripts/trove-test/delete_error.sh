#!/bin/bash
for i in `trove list | awk '{print $2}'`;do
    trove delete $i;
done
