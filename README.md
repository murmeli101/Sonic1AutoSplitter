# Sonic1AutoSplitter

LiveSplit autosplitter for Sonic the Hedgehog (Sega Mega Drive / Genesis).





## Currently supported versions
- Steam (Simple launcher)

## How to use

1. Open LiveSplit
2. Edit Splits...
3. Look for 'Sonic the Hedgehog'
4. Click Activate
5. (Compare against -> Game Time)

Or alternatively:

1. Download Sonic1.asl
2. Open LiveSplit
3. Edit layout...
4. Add Scriptable Auto Splitter
5. Double click it and set Script Path to Sonic1.asl
6. (Compare against -> Game Time)

Make sure that you have 19 splits in total. You can name them whatever you want.

AutoSplitter resets only when lives go to 0. You can always reset manually.

## Known issues

- Timer starts after starting a level in level select.
- If the demo starts, you have to wait until 0:01 before pressing start. otherwise the timer refuses to start.
- Sometimes Auto Splitter fails to update the minute counter and falls exactly 1 minute behind the actual time.
