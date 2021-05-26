
/////////////////////////////////////////////////////GRANULAR SYNTHESIS/////////////////////////////////////////////////////////


~path = (PathName(thisProcess.nowExecutingPath)).pathOnly;    //defining path with sound samples


(   // Load Samples for analysing variations

    ~files = SoundFile.collect(~path ++ "Samples/*");          // collect soundfiles from path
    ~buffers = ~files.collect { |sf| var b;                                  // store into buffers and declare as local b variable
	b = Buffer.read(Server.local, sf.path)}                            // send buffers to Server (?)
)


(

b = ~buffers[7];
c = ~buffers[7];
d = ~buffers[10];
~sb = Buffer.alloc(s,1024,1);

{
	var snd, amp, pos, fft, centroid, synth, trig, dur, density, spread, level, center;

	snd = PlayBuf.ar(1, b, 0.5);
	amp = Amplitude.ar(snd, 1.0, 1.5).linlin(0.0, 1.0, 0.0, 20.0);
	fft = FFT(~sb, snd);
	centroid = SpecCentroid.kr(fft).linlin(0, 10000, 50, 10000);
	pos = amp.linlin(0.0,2.5,1,-1);
	dur = amp.linlin(0, 2.0, 0.08, 0.1).poll;
	density = XLine.ar(500, 1000, 5);
	trig = Dust.ar(density);
	spread = 1;
	level = 0.06;
	center = 0;
	synth = Splay.arFill(20,
		{
		var carfreq =rrand(100, 300);
		var modfreq = rrand(100, 200);
		var index = EnvGen.kr(Env.new([0.1, 2, 1, 1.5, 2, 1.2, 1, 2], [50,40,20,20, 25, 19, 20]));
			var mix = amp.linlin(0,2.5, 0.5, 0.1);
			var room = 0.5;
			var damp = 0.6;
			var sound = FreeVerb.ar(FMGrain.ar(trig, dur, carfreq, modfreq, index), mix, room, damp );
		Pan2.ar( sound * amp.linlin(0, 2.5, 0, 0.4), pos)
	                   },
	                  spread, level, center)
}.play

)




//////////////////////////realistic wind |||||||||||||||||\\\\\\\\\\\\\\\\\

(

b = ~buffers[7];
c = ~buffers[7];
d = ~buffers[10];
~sb = Buffer.alloc(s,1024,1);

{
	var snd, amp, pos, fft, centroid, env, synth, trig, dur, density;

	snd = PlayBuf.ar(1, b, 1);
	amp = Amplitude.ar(snd, 1.0, 1.5).linlin(0.0, 1.0, 0.0, 20.0);
	fft = FFT(~sb, snd);
	centroid = SpecCentroid.kr(fft).linlin(0, 10000, 50, 10000);
	pos = amp.linlin(0.0,2.9,-0.8,0.8);
	dur = amp.linlin(0, 2.0, 0.03, 0.1).poll;
	density = amp.linlin(0, 2.5, 500, 1000);
	trig = Dust.ar(density);
	synth = Mix.fill(20, {
		var carfreq = rand(centroid).linlin(100,250,700,720);
		var modfreq = rand(centroid);
						var sound = FMGrain.ar( trig, dur, carfreq, modfreq, amp.linlin(0, 2.5, 0.2, 10));
		Pan2.ar( sound * amp.linlin(0, 2.5, 0.0, 0.01), pos, 0.4)});
}.play

)