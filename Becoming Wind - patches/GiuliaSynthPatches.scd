
~path = (PathName(thisProcess.nowExecutingPath)).pathOnly;    //defining path with sound samples

(   // Load Samples for analysing variations

~files = SoundFile.collect(~path ++ "Samples/*"); // I changed this!
    ~buffers = ~files.collect { |sf| var b;
	b = Buffer.read(Server.local, sf.path)}
)


(

b = ~buffers[7]; // I changed this!
~sb = Buffer.alloc(s,1024,1);

)

Ndef.clear;

//// 0 - Original ////

(

Ndef(\snd0).fadeTime = 5;

Ndef(\snd0, {

	var snd, amp, pos, synth, trig, dur, density;

	snd = PlayBuf.ar(1, b, 1.5, loop:1);
	amp = Amplitude.ar(snd, 1.0, 2.0).linlin(0.0, 1.0, 0.0, 20.0);
	pos = amp.linlin(0.0,2.5,0.65,-0.65);
	dur = amp.linlin(0, 2.0, 0.03, 0.1);
	density = XLine.ar(300, 1000, 5);
	trig = Dust.ar(density);
	synth = Mix.fill(20, {
	var carfreq = exprand(100, 200);
	var modfreq = exprand(100, 200);
		var mix = amp.linlin(0, 2.5, 0.2, 0.05);
		var room = amp.linlin(0, 2.5, 0.3, 0.01);
		var sound = FreeVerb.ar(
			FMGrain.ar(trig, dur, carfreq, modfreq,
				EnvGen.kr(Env.new([0.1, 3.5, 2, 2.5, 2.1, 1.5, 4, 1.3], [30,20,15,30, 20, 20, 20]))),
			mix, room, 0.1 );
		Pan2.ar( sound * amp.linlin(0, 2.5, 0, 0.01), pos, 0.5)});
}).play

)

//// 1 - ClipNoise through bandpass filters ////


(

Ndef(\snd1).fadeTime = 5;

Ndef(\snd1, {

	var snd, amp, freqs, noise, sig, channels=8;
	var start = 100, step = 10, bw=0.08;

    snd = PlayBuf.ar(1, b, 1, loop:1);
	amp = Amplitude.ar(snd, 1.0, 2.0).linlin(0.0, 1.0, 0.0, 20.0);
	freqs = Array.series(channels, start, step);
	noise = LFClipNoise.ar(75000, 0.5); // Try a differnt noise
    //	noise = Crackle.ar(1.99);
	sig = BBandPass.ar(noise, amp.range(0.3,1.5) * rand(freqs), bw);
	sig = sig * amp.range(0.1, 2);

	Splay.ar ( sig )

}).play

)

//// 2 - Sine + PinkNoise, BPF and Onsets ////

(

~sb = Buffer.alloc(s, 512);

Ndef(\snd2).fadeTime = 5;

Ndef(\snd2, {|rate=40, grAtk=1, grRel=1.5, bw=0.1, filtFrom=100,filtBw=100|

	var secRate = Array.series(8,filtFrom,filtBw);

	var chain = FFT(~sb, PlayBuf.ar(2, b, loop:1));
	var trigger= Onsets.kr(chain, 0.1, \complex);

	var env= EnvGen.ar(Env.perc(grAtk, grRel, 0.5, 4), trigger, 1, 0, (2/rate));
	var sig = HPF.ar(SinOsc.ar([rate/3, rate], 0, env) + BPF.ar(PinkNoise.ar(mul:env), secRate, bw), 40);

	Splay.ar ( sig )

}).play;

)

//// 3 - Split analysing to hi and lo with 4 different noises ////

Ndef.clear

(

Ndef(\snd3).fadeTime = 10;

Ndef(\snd3, {

	var snd = PlayBuf.ar(1, b, 1.5, loop:1);
	var ampLo = Amplitude.ar(LPF.ar(snd * 10, 500), 0.15, 0.1);
	var ampHi = Amplitude.ar(HPF.ar(snd * 10, 2000), 0.01, 0.05);
	var sig = [ GrayNoise.ar, PinkNoise.ar, LFDClipNoise.ar, LFDNoise3.ar ] * 0.25;

	var lo = RLPF.ar(sig,ampLo.range(20,150).poll, 10, 1);
	var hi = RHPF.ar(sig,ampHi.range(7000,8000), 0.02, 0.5);
	sig = lo + hi;

	Splay.ar ( sig )

}).play;

)


//// 4 - Different envelopes for 8 noise channels and using loudness for amplitude tracking ////

Ndef.clear

(

~sb2 = Buffer.alloc(s,1024,1);

Ndef(\snd4).fadeTime = 5;

Ndef(\snd4, {

	var snd = PlayBuf.ar(2, b, loop:1);
	var fft = FFT(~sb, snd);
	var loudness = Loudness.kr(fft).linlin(0, 100, 0, 2);    // how is it different from Amplitude tracking?

	var signal = Array.fill(10, {
		var a, b;
		var enva = EnvGen.kr(Env([rrand(20, 40), rrand(50, 65), rrand(60, 100)], [0.1.rand,0.25.rand]).circle);
		var envb = EnvGen.kr(Env([rrand(5000, 8000), rrand(11000, 10000), rrand(4000, 11000)], [0.05.rand,0.1.rand]).circle);
		a = RLPF.ar(GrayNoise.ar(0.3) + Dust.ar(100), enva);
		b = RHPF.ar(GrayNoise.ar(0.3) + Dust.ar(10), envb);
		(a + b) * loudness
	});

    Splay.ar ( signal )

}).play

)
