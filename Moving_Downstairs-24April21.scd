///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

(
~path = (PathName(thisProcess.nowExecutingPath)).pathOnly;    //defining path with samples
  // Load Samples

    ~files = SoundFile.collect(~path ++ "Samples/*");
    ~buffers = ~files.collect { |sf| var b;
	b = Buffer.read(Server.local, sf.path)};
    ~path = (PathName(thisProcess.nowExecutingPath)).pathOnly;
    ~path = ~path ++ "Samples/";
    ~windmono = Buffer.read(s, ~path ++ "IsolatedWindExpanderMONO.wav");
)

Ndef.clear  //2.

(
b = ~windmono    //3.
)

//////////////////////////////// amplitude follower////////////////////////////////////

(
(
Ndef(\followerN).fadeTime = 0.01;
Ndef(\followerN, {|followerInputGain=1, followerCut=10000,gate1=1,gate2=1|

var follower, snd, followerInterrupted;

	snd = BufRd.ar(numChannels: 1, bufnum: b,
		phase: Phasor.ar( trig: 0, rate: BufRateScale.kr( b ) * 1, start: 0, end: BufFrames.kr( b )),loop:1);

	follower = Amplitude.ar(LPF.ar(snd * followerInputGain * 1 , followerCut), attackTime:0.1, releaseTime:0.3).linlin(0.0, 0.9, 0.0, 0.99);

	followerInterrupted = Gate.ar(follower,LFPulse.kr(1.33,0.5).linlin(0,1,gate1,gate2));
}));

(
Ndef(\followerInterruptedN).fadeTime = 0.01;
Ndef(\followerInterruptedN, {|followerInputGain=1, followerCut=2000|
		var follower, snd, followerInterrupted;

	snd = BufRd.ar(numChannels: 1, bufnum: b,
		phase: Phasor.ar( trig: 0, rate: BufRateScale.kr( b ) * 1, start: 0, end: BufFrames.kr( b )));

	follower = Amplitude.ar(LPF.ar(snd * followerInputGain * 1 , followerCut), attackTime:0.1, releaseTime:0.3).linlin(0.0, 0.99, 0.0, 0.999);

	followerInterrupted = Gate.ar(follower,LFPulse.kr(1.33,0.5).linlin(0,1,1,1));
}));

//linlin(0,1,0,0) == stop control data
//linlin (0,1,1,1) == play control data without interruption (gate just doesn't work)

//////

(
Ndef(\followerFlippedN).fadeTime = 0.01;
Ndef(\followerFlippedN, {|followerInputGain=1, followerCut=10000, gate1=1,gate2=1|

		var follower, snd, followerRescaled, followerInterrupted;

	snd = BufRd.ar(numChannels: 1, bufnum: b,
		phase: Phasor.ar( trig: 0, rate: BufRateScale.kr( b ) * 1, start: 0, end: BufFrames.kr( b )),loop:1);

	follower = Amplitude.ar(LPF.ar(snd * followerInputGain * 1 , followerCut), attackTime:0.1, releaseTime:0.3).linlin(0.0, 0.99, 0.0, 0.99);

	followerRescaled = follower.linlin(0.0, 0.99, 0.99, 0.0);

	followerInterrupted = Gate.ar(followerRescaled,LFPulse.kr(1.33,0.5).linlin(0,1,gate1,gate2));
}));

//////
(
Ndef(\followerscaled1N).fadeTime = 0.01;
Ndef(\followerscaled1N, {|followerInputGain=1, followerCut=10000, minval=0.0, maxval=1.0, gate1=1, gate2=1|
			var follower, snd, followerInterrupted;

	snd = BufRd.ar(numChannels: 1, bufnum: b,
		phase: Phasor.ar( trig: 0, rate: BufRateScale.kr( b ) * 1, start: 0, end: BufFrames.kr( b )),loop:1);


	follower = Amplitude.ar(LPF.ar(snd * followerInputGain , followerCut), attackTime:0.01, releaseTime:0.3).linlin(0.0, 0.99, minval, maxval);

	followerInterrupted = Gate.ar(follower,LFPulse.kr(1.33,0.5).linlin(0,1,gate1,gate2));
}));
)

///////////////////////////////spectral centroid tracker///////////////////////////////
//1. allocate a Buffer + setup OSC responder
(
s = Server.local;
c = Buffer.alloc(s, 44100 * 10.0, 1);                                    // a ten seconds 1 channel Buffer
~sb = Buffer.alloc(s, 2048);
)
((
Ndef(\centroid).fadeTime=0.01;
Ndef(\centroid, { |rate=1, minval=20, maxval=10000, gate1=1, gate2=1|

	var  input,fft, tracker, snd, trackerRescaled, trackerInterrupted;

	snd = BufRd.ar(numChannels: 1, bufnum: b,
		phase: Phasor.ar( trig: 0, rate: BufRateScale.kr( b ) * 1, start: 0, end: BufFrames.kr( b )),loop:1);
    fft = FFT(~sb, snd);
    tracker = SpecCentroid.kr(fft);
    trackerRescaled = tracker.linlin(20, 20000, minval, maxval);
	trackerInterrupted = Gate.kr(trackerRescaled,LFPulse.kr(1.33,0.5).linlin(0,1,gate1,gate2));
}));

(
Ndef(\centroidRescaled1).fadeTime=0.01;
Ndef(\centroidRescaled1)[0] = { |rate=1, minval=20, maxval=10000,gate1=1,gate2=1|

	var  input,fft, tracker, snd, trackerRescaled, trackerInterrupted;

	snd = BufRd.ar(numChannels: 1, bufnum: b,
		phase: Phasor.ar( trig: 0, rate: BufRateScale.kr( b ) * 1, start: 0, end: BufFrames.kr( b )));
    fft = FFT(~sb, snd);
    tracker = SpecCentroid.kr(fft);
    trackerRescaled = tracker.linlin(20, 20000, minval, maxval);
	trackerInterrupted = Gate.kr(trackerRescaled,LFPulse.kr(1.33,0.5).linlin(0,1,gate1,gate2));
});
)

//-----------------------------------

(
Ndef(\sound5).fadeTime = 15;
Ndef(\sound5)[0] =  {|amploc=0.8, freqLo=100, amp=1.5| RLPF.ar((SinOsc.ar([10, 20]).mod(LFNoise1.ar(1000)) * 0.5 ), freqLo, 0.1, 0.01) * amploc * amp};
Ndef(\sound5)[1] =  {|amploc=0.8, freqHi=10000, densityHi=100| RHPF.ar((Saw.ar([2,3]).mod(LFNoise1.ar(densityHi)) * 0.5), freqHi, 0.1, 0.5) * amploc};
Ndef(\sound5)[2] = \filter -> { |in, amp=1| (in * amp)};
Ndef(\sound5)[3] = \filter -> {|in, lagTime=1, numCh=8, panCenter=2|
	var pan, out;
	pan = Lag.ar((Ndef(\followerN).ar * numCh - numCh / panCenter), lagTime);
	out = (PanAz.ar(2, in, pan, 1, 2.0))};
)

//2-3
Ndef(\sound5).xset(\amp, 1.8);                                     //unmap ndef on GLOBAL AMP
Ndef(\sound5).xset(\freqHi, 7000);   //parti a 8000
Ndef(\sound5).xset(\freqLo, 100);
Ndef(\sound5).xset(\densityHi, 5000);   //parti giocando con la density


Ndef(\sound5).play(2,2)
Ndef(\sound5).clear
Ndef(\sound5).stop(10)

//----------------------------------


//-----------------------------------------------
(
Ndef(\impulses).fadeTime = 1.0;
Ndef(\impulses)[1] = {|amploc=1,freqHi=150, numharm1=1000, numharm2= 1000,delaytm=1.0, decaytm=1.0,atk=0.001,amp=1, decay=10.5, feedback=0.0, delayedsig=0.0, tempolow=0.5, tempohigh=1.5|
		var trigger, sig, sig2, snd, env, input1,input2,output, outsig1, outsig2;
	//trigger = Impulse.kr(rrand(0.5,1.5));
	input1 = Blip.ar(Ndef(\followerscaled1N), numharm1, 1.0);
	sig = (RHPF.ar(GVerb.ar(in:SwitchDelay.ar(input1,1,delayedsig,delaytm,feedback,40), roomsize:1, revtime:TRand.kr(3, 5, Dust.kr(0.1)), drylevel:0.9), freqHi, 0.2, 0.09) * amploc);
	input2 = Blip.ar(Ndef(\followerscaled1N), numharm2, 1.0);
	sig2 = (RHPF.ar(GVerb.ar(in:AllpassC.ar(input2, 40.0, delaytm,decaytm), roomsize:2, revtime:TRand.kr(2, 5, Dust.kr(0.1)), drylevel:0.9), freqHi, 0.2, 0.09) * amploc);

	//env = EnvGen.kr(Env.perc(atk, decay, amp), trigger, doneAction:1);
	//snd = (sig + sig2)  * env;
	//snd = ((sig + sig2) * amp) * env;
	//outsig1 = sig * env;
	//outsig2 = sig2 * env;

	//snd = outsig1 + outsig2;
	snd = sig + sig2;
	output = Limiter.ar(snd,0.96,0.001);
})


Ndef(\impulses).play(0,2)
Ndef(\impulses).stop

Ndef.clear


Ndef(\impulses).xset(\amp, 1);
Ndef(\impulses).xset(\freqHi, 150);
Ndef(\impulses).xset(\decay, 10.0);
Ndef(\impulses).xset(\numharm1, 1000);
Ndef(\impulses).xset(\numharm2, 1000);
Ndef(\impulses).xset(\delaytm, 0.15);           //inizio 1.0, poi 0.15 !!!!!
Ndef(\impulses).xset(\delaytm, Ndef(\centroid));
Ndef(\impulses).xset(\decaytm, 1.0);
Ndef(\impulses).xset(\feedback, 0.5);
Ndef(\impulses).xset(\delayedsig, 0.3);

//filter 150 , numharms 1000 for both, delaytime whatever , decay 10 sec, trigger default (rrand 0.5, 1.5)

//freq fissa del followerScaled1N a 10.3 + delay a 0.01 per fare stop static
// ritmo figo : harmonics fisse 1000, frwqHi 150, delaytm 0.15, delaytime decay 5.0

//inizio: filtro 150, delaytm 1.0, decaytime 1.0, harmonics 1000 both, decay 10 , tempo 0.5, 1.5, freq pulses 0.2 - 0.25, feedback 0.0

//dopo l'inizio, smarmella per un po', iniziando con centoird extremes 0.01-10.8 poi torna a questa seguente configurazione:

//second: freq pulses 0.3-0.8, delaytm 0.15,decaytm 1.0,fedbaack 0.5, tempo 0.5-1.5 --> gioca con i layer in ableton e piano piano alza il limite high di followerscaled1 da 0.8 in su.

//introduci sound5 e gioca per un po' (parti da pulses [2,3] poi raddoppia poi arriva a [10,20], giocaci
//poi dopo un bel po' reintroduci delay negli impulses e giocaci, togliendo all'inizio i due layer di ableton poi rimettendoli facendo muro di suono. togli i layers e rimani con impulsi smarmellati, rimetti un po' di layers e finisci così



///////////////////////////////////////////////////////actions

///// control signals

Ndef(\centroid).xset(\minval, 0.05)  //evaluate it !!
Ndef(\centroid).xset(\maxval, 10.8)

Ndef(\followerscaled1N).xset(\minval, 0.3)   //   inizio 0.2   poi   0.3
Ndef(\followerscaled1N).xset(\maxval, 1.33)  //   inizio 0.25    poi    0.8

Ndef(\centroidRescaled1).xset(\minval, 1000)
Ndef(\centroidRescaled1).xset(\maxval, 2000)


Ndef(\followerN).xset(\followerInputGain, 3);

Ndef(\INthresholdServer).xset(\threshold, 0.89)









//STOP CONTROL DATA
(
Ndef(\followerN).xset(\gate1,0);
Ndef(\followerN).xset(\gate2,0);
Ndef(\followerFlippedN).xset(\gate1,0);
Ndef(\followerFlippedN).xset(\gate2,0);
Ndef(\followerscaled1N).xset(\gate1,0);
Ndef(\followerscaled1N).xset(\gate2,0);
Ndef(\centroid).xset(\gate1, 0);
Ndef(\centroid).xset(\gate2, 0);
Ndef(\centroidRescaled1).xset(\gate1,0);
Ndef(\centroidRescaled1).xset(\gate2,0);
)
//PLAY CONTROL DATA
(
Ndef(\followerN).xset(\gate1,1);
Ndef(\followerN).xset(\gate2,1);
Ndef(\followerFlippedN).xset(\gate1,1);
Ndef(\followerFlippedN).xset(\gate2,1);
Ndef(\followerscaled1N).xset(\gate1,1);
Ndef(\followerscaled1N).xset(\gate2,1);
Ndef(\centroid).xset(\gate1, 1);
Ndef(\centroid).xset(\gate2, 1);
Ndef(\centroidRescaled1).xset(\gate1,1);
Ndef(\centroidRescaled1).xset(\gate2,1);
)