
                                                          //////// MULTICHANNEL AUTOMATIC PANNING //////////

~path = (PathName(thisProcess.nowExecutingPath)).pathOnly;    //defining path with samples


(   // Load Samples

    ~files = SoundFile.collect(~path ++ "Samples/*");
    ~buffers = ~files.collect { |sf| var b;
	b = Buffer.read(Server.local, sf.path)}
)

(
    ~path = (PathName(thisProcess.nowExecutingPath)).pathOnly;
    ~path = ~path ++ "Samples/";
	~wind = Buffer.read(s, ~path ++ "IsolatedWindExpander.wav");
    ~windmono = Buffer.read(s, ~path ++ "IsolatedWindExpanderMONO.wav");
    ~windrealmono = Buffer.read(s, ~path ++ "wind_real_mono.wav");
~filtnoise = Buffer.read(s, ~path ++ "ReplaceNoiseWindMono.wav");
~filtwhitenoise = Buffer.read(s, ~path ++ "FiltWhiteNoiseMono.wav");
~noiseFM = Buffer.read(s, ~path ++ "NoiseFMmono.wav");
~filtnoise2 = Buffer.read(s, ~path ++ "FilteredNoise2.aiff");
~filtnoise1 = Buffer.read(s, ~path ++ "FiltNoiseFROMStillTOMovements.aiff");
~filtnoise1left = Buffer.read(s, ~path ++ "FiltNoiseStillMov1LEFT-MONO.wav");
~filtnoise1right = Buffer.read(s, ~path ++ "FiltNoiseStillMov1RIGHT-MONO.wav");
~filtnoise2left = Buffer.read(s, ~path ++ "FiltNoise2LEFT.wav");
~filtnoise2right = Buffer.read(s, ~path ++ "FiltNoise2RIGHT.wav");
~ambiwind1 = Buffer.read(s,~path ++ "2.wav");
~ambiwind2 = Buffer.read(s,~path ++ "3.wav");
~ambiwind3 = Buffer.read(s,~path ++ "4.wav");
~fm = Buffer.read(s,~path ++ "FMtextMono.wav");
)

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

(

b = ~windmono;
c = ~fm;
)

(
SynthDef(\sampler, {
	|bufferFollow, bufferPlay, gate=1, followerInputGain = 0.0, lagTime=3, numCh = 8, panWdt=2, rateFollowerBuf=1,  ratePlayBuf=1, panCenter=2, outFollower= 12|
	var envelope;
	var snd, follower, sendFollower, pan, smpl;

	envelope = EnvGen.kr(Env.adsr(0.01, 0.3, 1, 0.6), gate);          //global envelope

	snd = BufRd.ar(                                                                              //control signal for amplitude following
		numChannels: 1,
		bufnum: bufferFollow,
		phase: Phasor.ar(
			trig: 0,
			rate: BufRateScale.kr( bufferFollow ) * rateFollowerBuf,
			start: 0,
			end: BufFrames.kr( bufferFollow )
		));


	follower = Amplitude.ar(LPF.ar(snd * followerInputGain * 1 , 3000), attackTime:0.1, releaseTime:0.3);  //amplitude follower

	Out.kr(outFollower, follower);

	pan = Lag.ar(                                                                                 //control signal mapped on panning parameter

		in: follower * numCh - numCh / panCenter,

		lagTime: lagTime
	    );


	smpl = BufRd.ar(
		numChannels: 1,
		bufnum: bufferPlay,
		phase: Phasor.ar(
			trig: 0,
			rate: BufRateScale.kr( bufferPlay ) * ratePlayBuf,
			start: 0,
			end: BufFrames.kr( bufferPlay )
		));

	Out.ar(0, (PanAz.ar(2, smpl, pan,1, Lag.kr(panWdt, lagTime))) * envelope);


}).add;
)


// ---------------------------------------------------------------
// ---------------------------------------------------------------
// play it

x = Synth(\sampler, [\bufferFollow, b, \bufferPlay, c,\followerInputGain, 1.0, \lagTime, 3, \attackTime, 0.2, \releaseTime,  0.3, \panCenter, 2.0, \panWdt, 2.5, \pan, 1  ]);

x.set(\followerInputGain, 9.8);
x.set(\lagTime, 3);     ////length of the fade of parameters !!!
x.set(\attackTime, 0.2 );
x.set (\releaseTime,  0.3);
x.set(\panCenter, 2.0);
x.set(\panWdt, 2.0);
x.set(\pan, 1);

x.set(\rateFollowerBuf, 1);
x.set(\ratePlayBuf, 1);


x.set(\gate, 0);
x.set(\gate, 1);

s.makeGui
x.free


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
           ///////////////////////////////////////////// CREATE THE NetAddr////////////////////////////////////////


~ntwork = NetAddr.new("127.0.0.1", 7500);
~ntwork.sendMsg("cccc");


///////HOW TO SEND DATA THROUGH THE NETWORK  (example)///////


Ndef.clear
Ndef(\data).fadeTime = 1;

(
Ndef(\data, {
	|input = 10|

	VarLag.kr(input, 0.5);                     // input is run through a VarLag, which ramps the value over 0.5 seconds
})
)

/////// Create a Routine to read from your Ndef bus and send to your ~ntwork

(
Routine({
	inf.do {
		var data = Ndef(\data).bus.getSynchronous.postln;  // Get the value from the bus your Ndef is writing to
		~ntwork.sendMsg("data", data);                                       // Send your volume value.
		(1/20).wait;                                                                             // Repeat 20 times / second. If you skip this line, you won't wait
                                                 	                                                   // between loops - you'll loop forever and lock the app!
	}
}).play;
)

Ndef.clear


// Okay, now if you set your Ndef(\data)'s \input parameter,
// it will slowly ramp to that value over 1.5 seconds. Your looping
// Routine will send the value as it changes to your ~ntwork.
Ndef(\data).set(\input, 20.0);

Ndef(\data).set(\input, 0.5);



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////// MY SYSTEM//////////////////////////////////////////////////////////////////

//////////// OSC network

~ntwork = NetAddr.new("127.0.0.1", 7500);
~ntwork.sendMsg("cccc");


//////////Ndef receives data from synthdef

Ndef.clear
Ndef(\data).fadeTime = 1;

(
Ndef(\data, {

	var input;

	input = In.kr(12);                                 // data from the follower variable of the SynthDef

	VarLag.kr(input, 0.5);                     // input is run through a VarLag, which ramps the value over 0.5 seconds
})
)

////////////routine iterates data of the Ndef

(
Routine({
	inf.do {
		var data = Ndef(\data).bus.getSynchronous.postln;  // Get the value from the bus your Ndef is writing to
		~ntwork.sendMsg("data", data);                                       // Send your volume value.
		(1/20).wait;                                                                             // Repeat 20 times / second. If you skip this line, you won't wait
                                                 	                                                   // between loops - you'll loop forever and lock the app!
	}
}).play;
)

/////////////that's it
















OSCFunc.trace(true); // Turn posting on
OSCFunc.trace(false); // Turn posting off



