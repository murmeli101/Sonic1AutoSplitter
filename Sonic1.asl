state("SEGAGenesisClassics")
{
	byte seconds : "SEGAGenesisClassics.exe", 0x2D69D9;
	byte minutes : "SEGAGenesisClassics.exe", 0x2D69D6;
	byte lives   : "SEGAGenesisClassics.exe", 0x2D69C7;
	byte level   : "SEGAGenesisClassics.exe", 0x2D6B36;
	byte introPlaying: "SEGAGenesisClassics.exe", 0x2B31CA;
	// byte demoPlaying: "SEGAGenesisClassics.exe", 0x2D3BB5;
	byte finalSplit:  "SEGAGenesisClassics.exe", 0x2D3BB5;
	byte pressedStart:  "SEGAGenesisClassics.exe", 0x2D6A12;
}

start
{
	if (current.seconds == 0 && current.minutes == 0 && current.lives == 3 && current.introPlaying == 7) {
		current.demoStarted = true;
	}
	
	if (current.seconds == 1 && current.minutes == 0 && current.lives == 3 && current.introPlaying == 0 && current.demoStarted == true) {
		current.demoStarted = false;
	}

	if (current.seconds == 0 && current.minutes == 0 && current.lives == 3 && current.introPlaying != 7) {
		current.totalTime = 0;
		current.addedTime = 0;
		current.levelCounter = 0;
		current.level17time = 0;
		current.levelTime = 0;
		return (current.introPlaying == 0 && current.demoStarted == false && current.pressedStart == 0);
	}
}

reset
{
	return (current.lives == 0);
}

init
{
	current.totalTime = 0;
	current.addedTime = 0;
	current.previousLives = 3;
	current.level17time = 0;
	current.levelTime = 0;
	current.levelCounter = 0;
	current.demoStarted = false;
}

split
{
	// Next level
	if (current.seconds == 0 && current.minutes == 0 && (old.minutes*60 + old.seconds) > 0 && current.lives == current.previousLives && current.levelCounter != 0) {
		if (current.levelCounter == 17) {
			current.addedTime += current.level17time;
			current.level17time = 0;
		}
		else {
			current.addedTime += current.levelTime;
		}
		current.levelCounter += 1;
		current.previousLives = current.lives;
		current.levelTime = 0;
		return true;
		
	// First level
	} else if (current.seconds == 0 && current.minutes == 0 && (old.minutes*60 + old.seconds) > 23 && current.lives == current.previousLives && current.levelCounter == 0) {
		current.addedTime += old.minutes*60 + old.seconds;
		current.levelCounter = 1;
		current.levelTime = 0;
		return true;
		
	// Final split
	} else if (current.finalSplit == 0 && current.levelCounter == 18 && current.lives == current.previousLives) {
		return current.finalSplit == 0;
	}
}

gameTime
{
	// Restart level
	if (current.seconds == 0 && current.minutes == 0 && (old.minutes*60 + old.seconds) > 0 && current.lives < current.previousLives) {
		current.addedTime += old.minutes*60 + old.seconds;

	// Delay updating previousLives by 1 second, so that restarting doesn't overlap with splitting
	} else if (current.seconds == 1 && current.minutes == 0 && (old.minutes*60 + old.seconds) > 0 && current.lives < current.previousLives) {
		current.previousLives = current.lives;
	}

	// Checkpoint
	if ((old.minutes*60 + old.seconds) > 0 && (current.minutes*60 + current.seconds) > 0 && (current.minutes*60 + current.seconds) < (old.minutes*60 + old.seconds) && current.lives != current.previousLives) {
		current.addedTime += (old.minutes*60 + old.seconds) - (current.minutes*60 + current.seconds);
		current.previousLives = current.lives;
		current.addedTime -= 1;
	}

	// Reset
	if (current.lives == 0) {
		current.totalTime = 0;
		current.addedTime = 0;
		current.levelTime = 0;
		current.previousLives = 3;
		current.demoStarted = false;
		current.levelCounter = 0;
	}

	// These are needed to make the broken 'second' value disappear before GH1 and Final Zone.
	if (current.seconds > 0 && current.seconds < 5 && current.minutes == 0 && current.lives == 3 && current.introPlaying == 0 && current.demoStarted == false && current.finalSplit == 0 && current.levelCounter == 0) {
		current.totalTime = 0;
		current.addedTime = 0;
	} else if ((current.minutes*60 + current.seconds) > 0 && current.finalSplit == 0 && current.levelCounter == 17) {
		if (current.level17time == 0 && current.lives == current.previousLives) {
			current.level17time = current.minutes*60 + current.seconds;
		}
	} else if ((current.minutes*60 + current.seconds) > 0 && current.levelCounter != 17) {
		if (current.lives == current.previousLives) {
			current.levelTime = current.minutes*60 + current.seconds;
		}
	}
	
	if ((current.minutes*60 + current.seconds) > (old.minutes*60 + old.seconds) && current.level17time == 0) { //  && current.levelCounter != 17
		current.totalTime = current.addedTime + current.minutes*60 + current.seconds; // Main counter
	}
	
	// Update extra lives
	if (current.lives > current.previousLives) {
		current.previousLives = current.lives;
	}

	return TimeSpan.FromSeconds(current.totalTime);


}

isLoading
{
	return true;
}
