
///////////////////////////////////////////GRANULATION + MULTICHANNEL PANNING//////////////////////////////////////

~path = (PathName(thisProcess.nowExecutingPath)).pathOnly;    //defining path with sound samples


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
~filtnoise1 = Buffer.read(s, ~path ++ "TxtureWindMONO.wav");
~filtnoise2left = Buffer.read(s, ~path ++ "FiltNoise2LEFT.wav");
~filtnoise2right = Buffer.read(s, ~path ++ "FiltNoise2RIGHT.wav");
~blabla = Buffer.read(s,~path ++ "blablaMONO.wav");
~noiselowhighleft = Buffer.read(s,~path ++ "NoiseLow+HighLEFTMONO.wav");
~noiselowhighright = Buffer.read(s,~path ++ "NoiseHigh+LowRIGHTMONO.wav");
~ambiwind1 = Buffer.read(s,~path ++ "2.wav");
~ambiwind2 = Buffer.read(s,~path ++ "3.wav");
~ambiwind3 = Buffer.read(s,~path ++ "4.wav");
)

//// Granulation of sounds driven by wind file
(

b = ~buffers[8]; // I changed this!
~sb = Buffer.alloc(s,1024,1);
c = ~filtwhitenoise;

)

c.play
Ndef.clear;

(

Ndef(\granular).fadeTime = 1;

Ndef(\granular, {

	var wind = PlayBuf.ar(1, b, 1, loop:0);
	var snd = PlayBuf.ar(1,c,0.1,loop:1);
	var ampLo = Amplitude.ar(LPF.ar(wind * 10 , 100), 0.15, 0.1);
	var gatesound = snd * ampLo.linlin(0,1,-1,1).poll;
	var rate = ampLo.linlin(0.0, 1.0, 0.5, 20.0).poll;                                           //triggering rate modulated by amp
	var trig
	= Impulse.kr(rate);

	var global =  Mix.fill(10,{
	TGrains.ar(2, trig, c, TRand.kr(0.1,0.5,trig),
			             TRand.kr(0.01,0.5,trig), ampLo.linlin(0, 1, 0.1, 2.0),
			TRand.kr(-1.0,1.0,trig), ampLo.linlin(0,1, 0.0, 0.7))});

	Gate.ar(global, gatesound);
}).play

)

///////////////////////////////////////////SynthDef method//////////////////////////////////////////////////////
(

b = ~windmono;

c = ~ambiwind1;

)


(
SynthDef(\sampler, {
	|bufferFollow, bufferPlay, gate=1, followerInputGain = 0.1, lagTime=0.2, numCh = 8, panWdt=2, rateFollowerBuf=1,          ratePlayBuf=1, durMin = 0.1, durMax = 1, ampMin = 0.3, ampMax = 0.3, rateMin=10, rateMax=60, grainRateMin = 1, grainRateMax  =2|
	var envelope;
	var snd, follower, smpl, pan;
	var rate, trig, mix, room, global;

	envelope = EnvGen.kr(Env.adsr(0.01, 0.3, 1, 0.6), gate);

	snd = BufRd.ar(
		numChannels: 1,
		bufnum: bufferFollow,
		phase: Phasor.ar(
			trig: 0,
			rate: BufRateScale.kr( bufferFollow ) * rateFollowerBuf,
			start: 0,
			end: BufFrames.kr( bufferFollow )
		));


	follower = Amplitude.ar(LPF.ar(snd * followerInputGain * 10, 5000), attackTime:0.3, releaseTime:0.4).poll;



    pan = Lag.ar(

		in: follower * numCh - numCh / 2,

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

	rate = follower.linlin(0,1, rateMin, rateMax);

	trig = Impulse.kr(rate);

global = Mix.fill(10,{
		TGrains.ar(1, trig, c, Lag.ar(in:TRand.ar( grainRateMin,grainRateMax,trig), lagTime: lagTime),
			TRand.kr(0.01,0.5,trig), follower.linlin(0, 1, durMax, durMin),
			TRand.kr(-1.0,1.0,trig), follower.linlin(0,1, ampMin, ampMax))});


	Out.ar(0, (PanAz.ar(8, global, pan,1, panWdt))* envelope);
}).add;
)

s.makeGui

// play it

x = Synth(\sampler, [\bufferFollow, b, \bufferPlay, b, \followerInputGain, 1.0, \lagTime, 5, \attackTime, 0.1, \releaseTime, 0.1, \grainRateMin, 1, \grainRateMax, 1, \rateMin, 20, \rateMax, 40, \durMin, 1.0, \durMax, 3, \ampMin, 0.1, \ampMax, 0.5]);

x.set(\followerInputGain, 0.0);
x.set(\lagTime, 5);
x.set(\attackTime, 0.1 );
x.set (\releaseTime,  0.1);
x.set(\grainRateMin, 1);
x.set(\grainRateMax, 1);
x.set(\rateMin, 20);
x.set(\rateMax, 50);
x.set(\durMin, 1.0);
x.set(\durMax, 3.0);
x.set(\ampMin, 0.1);
x.set(\ampMax, 0.2);
x.set(\panWdt, 4.0);
//x.set(\pan, 1.0);

x.set(\rateFollowerBuf, 1); // this is a tricky one but is working
x.set(\ratePlayBuf, 1);


x.set(\gate, 0); // close it without freeing
x.set(\gate, 1); // start again




