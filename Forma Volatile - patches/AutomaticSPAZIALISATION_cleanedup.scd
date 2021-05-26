
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
c = ~ambiwind1;
)

(
SynthDef(\sampler, {
	|bufferFollow, bufferPlay, gate=1, followerInputGain = 0.0, lagTime=3, numCh = 8, panWdt=2, rateFollowerBuf=1,  ratePlayBuf=1, panCenter=2|
	var envelope;
	var snd, follower, pan, smpl;

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

	Out.ar(0, (PanAz.ar(8, smpl, pan,1, Lag.kr(panWdt, lagTime))) * envelope);


}).add;
)

// ---------------------------------------------------------------
// ---------------------------------------------------------------
// play it

x = Synth(\sampler, [\bufferFollow, b, \bufferPlay, c,\followerInputGain, 1.0, \lagTime, 3, \attackTime, 0.1, \releaseTime,  0.3, \panCenter, 2.0, \panWdt, 2.5, \pan, 1  ]);

x.set(\followerInputGain, 3.8);
x.set(\lagTime, 3);     ////length of the fade of parameters !!!
x.set(\attackTime, 0.1 );
x.set (\releaseTime,  0.3);
x.set(\panCenter, 2.0);
x.set(\panWdt, 4.5);
x.set(\pan, 1);

x.set(\rateFollowerBuf, 1);
x.set(\ratePlayBuf, 1);


x.set(\gate, 0);
x.set(\gate, 1);

s.makeGui






