
~path = (PathName(thisProcess.nowExecutingPath)).pathOnly;    //defining path with sound samples


(   // Load Samples for analysing variations

    ~files = SoundFile.collect(~path ++ "Samples/*");          // collect soundfiles from path
    ~buffers = ~files.collect { |sf| var b;                                  // store into buffers and declare as local b variable
	b = Buffer.read(Server.local, sf.path)}                            // send buffers to Server (?)
)


~buffers[7].play

(

b = ~buffers[7];
c = ~buffers[7];
d = ~buffers[10];
~sb = Buffer.alloc(s,1024,1);

{
	var snd, amp, pos, fft, centroid, env, synth, trig, dur, density, envbuf = b;

	snd = PlayBuf.ar(1, b, 0.5);
	amp = Amplitude.ar(snd, 1.0, 2.0).linlin(0.0, 1.0, 0.0, 20.0);
	fft = FFT(~sb, snd);
	centroid = SpecCentroid.kr(fft).linlin(0, 10000, 50, 10000);
	pos = amp.linlin(0.0,2.5,0.65,-0.65);
	dur = amp.linlin(0, 2.0, 0.01, 0.08).poll;
	density = XLine.ar(300, 1000, 5);
	trig = Impulse.ar(density);
	//env = EnvGen.kr(Env.new([0, 0.01], [5]));
	synth = Mix.fill(20, {
		var carfreq =rrand(1000, 2000);
	var modfreq = rrand(1000,3000);
		var mix = amp.linlin(0, 2.5, 0.5, 0.03);
		var room = amp.linlin(0, 2.5, 0.01, 0.3);
		var index = EnvGen.kr(Env.new([0.1, 6.5, 2, 7.5, 3, 4.5, 4, 2.3], [30,20,15,30, 20, 20, 20]));
		var sound = FreeVerb.ar(FMGrainB.ar(trig, dur, carfreq, modfreq, index, envbuf), mix, room, 0.1 );
		Pan2.ar( sound * amp.linlin(0, 2.5, 0, 0.01), pos, 0.5)});
}.play

)

z = Env([0, 1, 0], [1, 1], [10, -10]).asSignal(1024);
s.sendMsg(\b_alloc, b = s.bufferAllocator.alloc(1), 1024, 1, [\b_setn, b, 0, 1024] ++ z)





(
    SynthDef(\fm_grain_test, {arg gate = 1, amp = 1, envbuf;
    Out.ar(0,
        FMGrainB.ar(Impulse.kr(1000), 0.2, WhiteNoise.kr.range(440, 880), 200,
            LFNoise1.kr(1).range(1, 10), envbuf,
            EnvGen.kr(
                Env([0, 1, 0], [1, 1], \sin, 1),
                gate,
                levelScale: amp,
                doneAction: 2)
        )
    )
}).add;
)

z = Env([0, 1, 0], [1, 1], [10, -10]).asSignal(1024);
s.sendMsg(\b_alloc, b = s.bufferAllocator.alloc(1), 1024, 1, [\b_setn, b, 0, 1024] ++ z)
s.sendMsg(\s_new, \fm_grain_test, a=s.nextNodeID, 0, 1, \amp, 0.2, \envbuf, b);
s.sendMsg(\n_set, a, \gate, 0);
s.sendMsg(\b_free, b);