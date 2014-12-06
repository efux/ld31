#!/bin/zsh
~/Downloads/dart-sdk/bin/dart2js -o LD31.dart.js LD31.dart
exit;

dart2js="/tmp/dart-sdk/bin/dart2js"
files=`find ./**/*.dart`;

while read line;
do
	echo "CC $line";
	`$dart2js -o ${line}.js $line`;
done <<< $files
