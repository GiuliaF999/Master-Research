////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////implemented types of mapping of env follower data to amplitude of single patterns//////////

//---------synchronous behaviour------------

//  1 to 1 (same data, maybe rounded/scaled)

// 1 to -1 (flipped data)

// 1 to 1+n (data with an offset)

// 1 to interrupted 1 (data is interrupted sometimes)


//-------asynchronous behaviour-----------

// 1 to delayed 1 (with a time delay, it breaks the synchronicity)

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


~path = (PathName(thisProcess.nowExecutingPath)).pathOnly;    //defining path with samples

(   // Load Samples

    ~files = SoundFile.collect(~path ++ "Samples/*");
    ~buffers = ~files.collect { |sf| var b;
	b = Buffer.read(Server.local, sf.path)}
)

//----------------------------------------------------------------

(
    ~path = (PathName(thisProcess.nowExecutingPath)).pathOnly;
    ~path = ~path ++ "Samples/";
    ~windmono = Buffer.read(s, ~path ++ "IsolatedWindExpanderMONO.wav");
)


//-----------------------------------------------------------------

//--------------------------------------NDEFs for CONTROL DATA---------------------------------------------------

Ndef.clear              //1.

(
b = ~windmono    //2.
)

(
Ndef(\cntrlGlob).fadeTime = 2;
Ndef(\cntrlGlob, {|followerInputGain=3, followerCut=2000|

	var follower, snd;

	snd = BufRd.ar(numChannels: 1, bufnum: b,
		phase: Phasor.ar( trig: 0, rate: BufRateScale.kr( b ) * 1, start: 0, end: BufFrames.kr( b )));

	follower = Amplitude.ar(LPF.ar(snd * followerInputGain * 1 , followerCut), attackTime:0.1, releaseTime:0.3).linlin(0.0, 0.3, 0.0, 0.95).poll;

})
)

Ndef(\cntrlGlob).set(\followerInputGain, 1);
Ndef(\cntrlGlob).set(\followerCut, 200);



Ndef(\cntrlGlob).clear

//_______________


(
Ndef(\cntrlPan).fadeTime = 2;
Ndef(\cntrlPan, {|followerInputGain=1, followerCut=2000|

	var follower, snd, followerPan;

	snd = BufRd.ar(numChannels: 1, bufnum: b,
		phase: Phasor.ar( trig: 0, rate: BufRateScale.kr( b ) * 1, start: 0, end: BufFrames.kr( b )));

	follower = Amplitude.ar(LPF.ar(snd * followerInputGain * 1 , followerCut), attackTime:0.1, releaseTime:0.3).linlin(0.0, 0.3, 0.0, 0.95);

	followerPan = follower.linlin(0.0, 0.95, 0.0, 1.0);

})
)

//_________________

(
Ndef(\cntrlFlipped).fadeTime = 2;
Ndef(\cntrlFlipped, {|followerInputGain=1, followerCut=2000|
		var follower, snd, followerRescaled;

	snd = BufRd.ar(numChannels: 1, bufnum: b,
		phase: Phasor.ar( trig: 0, rate: BufRateScale.kr( b ) * 1, start: 0, end: BufFrames.kr( b )));

	follower = Amplitude.ar(LPF.ar(snd * followerInputGain * 1 , followerCut), attackTime:0.1, releaseTime:0.3).linlin(0.0, 0.3, 0.0, 0.95);

	followerRescaled = follower.linlin(0.0, 0.95, 0.95, 0.0);
});
)

//--------------------------------

(
Ndef(\cntrlOffset).fadeTime = 2;
Ndef(\cntrlOffset, {|followerInputGain=1, followerCut=2000|
		var follower, snd, followerRescaled;

	snd = BufRd.ar(numChannels: 1, bufnum: b,
		phase: Phasor.ar( trig: 0, rate: BufRateScale.kr( b ) * 1, start: 0, end: BufFrames.kr( b )));

	follower = Amplitude.ar(LPF.ar(snd * followerInputGain * 1 , followerCut), attackTime:0.1, releaseTime:0.3).linlin(0.0, 0.3, 0.0, 0.95);

	followerRescaled = follower.linlin(0.0, 0.95, 0.0, 0.95) + 0.1;
});
)

//-------------------------------

(
Ndef(\cntrlscaled1).fadeTime = 6;
Ndef(\cntrlscaled1, {|followerInputGain=1, followerCut=2000, minscaled1=0.01, maxscaled1=0.1|
		var follower, snd, followerRescaled;

	snd = BufRd.ar(numChannels: 1, bufnum: b,
		phase: Phasor.ar( trig: 0, rate: BufRateScale.kr( b ) * 1, start: 0, end: BufFrames.kr( b )));

	follower = Amplitude.ar(LPF.ar(snd * followerInputGain * 1 , followerCut), attackTime:0.1, releaseTime:0.3).linlin(0.0, 0.3, 0.0, 0.95);

	followerRescaled = follower.linlin(0.0, 0.95, minscaled1, maxscaled1);
});
)
Ndef(\cntrlscaled1).set(\minscaled1, 0.01);
Ndef(\cntrlscaled1).set(\maxscaled1, 0.1);

//_________________

(
Ndef(\cntrlscaled2).fadeTime = 6;
Ndef(\cntrlscaled2, {|followerInputGain=1, followerCut=2000, minscaled2=10, maxscaled2=30|
		var follower, snd, followerRescaled;

	snd = BufRd.ar(numChannels: 1, bufnum: b,
		phase: Phasor.ar( trig: 0, rate: BufRateScale.kr( b ) * 1, start: 0, end: BufFrames.kr( b )));

	follower = Amplitude.ar(LPF.ar(snd * followerInputGain * 1 , followerCut), attackTime:0.1, releaseTime:0.3).linlin(0.0, 0.3, 0.0, 0.95);

	followerRescaled = follower.linlin(0.0, 0.95, minscaled2, maxscaled2);
});
)


Ndef(\cntrlscaled2).set(\minscaled2, 10);
Ndef(\cntrlscaled2).set(\maxscaled2, 100);

//__________________

(
Ndef(\cntrlscaled3).fadeTime = 6;
Ndef(\cntrlscaled3, {|followerInputGain=1, followerCut=2000, minscaled3=10, maxscaled3=100|
		var follower, snd, followerRescaled;

	snd = BufRd.ar(numChannels: 1, bufnum: b,
		phase: Phasor.ar( trig: 0, rate: BufRateScale.kr( b ) * 1, start: 0, end: BufFrames.kr( b )));

	follower = Amplitude.ar(LPF.ar(snd * followerInputGain * 1 , followerCut), attackTime:0.1, releaseTime:0.3).linlin(0.0, 0.3, 0.0, 0.95);

	followerRescaled = follower.linlin(0.0, 0.95, minscaled3, maxscaled3);
});
)

Ndef(\cntrlscaled3).set(\minscaled3, 10);
Ndef(\cntrlscaled3).set(\maxscaled3, 100);

//________________

(
Ndef(\cntrlscaled4).fadeTime = 6;
Ndef(\cntrlscaled4, {|followerInputGain=1, followerCut=2000, minscaled4=10, maxscaled4=100|
		var follower, snd, followerRescaled;

	snd = BufRd.ar(numChannels: 1, bufnum: b,
		phase: Phasor.ar( trig: 0, rate: BufRateScale.kr( b ) * 1, start: 0, end: BufFrames.kr( b )));

	follower = Amplitude.ar(LPF.ar(snd * followerInputGain * 1 , followerCut), attackTime:0.1, releaseTime:0.3).linlin(0.0, 0.3, 0.0, 0.95);

	followerRescaled = follower.linlin(0.0, 0.95, minscaled4, maxscaled4);
});
)

Ndef(\cntrlscaled4).set(\minscaled4, 10);
Ndef(\cntrlscaled4).set(\maxscaled4, 100);

//________________

(

Ndef(\cntrlDelayed).fadeTime = 2;
Ndef(\cntrlDelayed, {|followerInputGain=1, followerCut=2000|
		var follower, snd, followerDelayed;

	snd = BufRd.ar(numChannels: 1, bufnum: b,
		phase: Phasor.ar( trig: 0, rate: BufRateScale.kr( b ) * 1, start: 0, end: BufFrames.kr( b )));

	follower = Amplitude.ar(LPF.ar(snd * followerInputGain * 1 , followerCut), attackTime:0.1, releaseTime:0.3).linlin(0.0, 0.3, 0.0, 0.95);

	followerDelayed = DelayC.kr(follower, maxdelaytime: 10, delaytime: EnvGen.kr(Env([0.0, 2.0, 0.0, 1.0], [40,20,40])));
});
)

//___________________

(

Ndef(\cntrlInterrupted).fadeTime = 2;
Ndef(\cntrlInterrupted, {|followerInputGain=1, followerCut=2000|
		var follower, snd, followerInterrupted;

	snd = BufRd.ar(numChannels: 1, bufnum: b,
		phase: Phasor.ar( trig: 0, rate: BufRateScale.kr( b ) * 1, start: 0, end: BufFrames.kr( b )));

	follower = Amplitude.ar(LPF.ar(snd * followerInputGain * 1 , followerCut), attackTime:0.1, releaseTime:0.3).linlin(0.0, 0.3, 0.0, 0.95);

	followerInterrupted = follower * Trig.ar(LFPulse.kr(follower.linlin(0.0, 0.95,0.5,7.0)), follower.linlin(0.0, 0.95, 0.1, 5.0));
});
)

//---- guis

(
Ndef(\cntrlGlob).gui;
Ndef(\cntrlscaled1).gui;
Ndef(\cntrlsclaed2).gui;
Ndef(\cntrlscaled3).gui;
)

//---------------------------------------NDEFs for sound generation-----------------------------------------


Ndef.clear


(
Ndef(\sound1).fadeTime = 6 ;
Ndef(\sound1)[0] = {|rq=0.05,amploc=0.8| RLPF.ar(GrayNoise.ar([0.09, 0.09]), 100, rq, 0.4) * amploc};
Ndef(\sound1)[1] = {|rq=0.05,amploc=0.8, freqHi=10000| RHPF.ar(GrayNoise.ar([0.09, 0.09]), freqHi, rq, 1) * amploc};
Ndef(\sound1)[2] = \filter -> {|in, amp=0.8| ( in * amp)};
Ndef(\sound1)[3] = \filter -> {|in, lagTime=1, numCh=8, panCenter=2|
	var pan, out;
	pan = Lag.ar((Ndef(\cntrlGlob).ar * numCh - numCh / panCenter), lagTime);
	out = (PanAz.ar(2, in, pan, 1, 2.0))};

)

//--
(
Ndef(\sound1comb).fadeTime = 20;
Ndef(\sound1comb)[0] = {|dtime1=0.01|CombC.ar(Ndef(\sound1).ar, 0.5, dtime1, 0.5)};
Ndef(\sound1comb)[1] = {|dtime2=0.005|CombC.ar(Ndef(\sound1).ar, 0.5, dtime2, 0.4)};
Ndef(\sound1comb)[2] = {|dtime3=0.008|CombC.ar(Ndef(\sound1).ar, 0.5, dtime3, 0.8)};
Ndef(\sound1comb)[3] = {|dtime4=0.5|CombC.ar(Ndef(\sound1).ar, 0.5, dtime4, 0.8)};
Ndef(\sound1comb)[4] = \filter -> {|in, amp=0.1| (in * amp)};
)

(
Ndef(\controlComb1).fadeTime=2;
Ndef(\controlComb1)[0] = {SinOsc.kr(0.03, 0).linlin(-1, 1, 0.01, 0.015)};
)

(
Ndef(\controlComb2).fadeTime=2;
Ndef(\controlComb2)[0] = {SinOsc.kr(0.05, 0).linlin(-1, 1, 0.005, 0.0055)};
)

(
Ndef(\controlComb3).fadeTime=2;
Ndef(\controlComb3)[0] = {SinOsc.kr(0.07, 0).linlin(-1, 1, 0.008, 0.0076)};
)

(
Ndef(\controlComb4).fadeTime=2;
Ndef(\controlComb4)[0] = {SinOsc.kr(0.06, 0).linlin(-1, 1, 0.5, 0.3)};
)


//_______________

(
Ndef(\sound2).fadeTime = 10 ;
Ndef(\sound2)[0] = {|rq=0.05,amploc=0.8|RLPF.ar(PinkNoise.ar([0.3,0.3]), 80, rq, 0.1) * amploc};
Ndef(\sound2)[1] = {|rq=0.05,amploc=0.8,freqHi=8000| RHPF.ar(PinkNoise.ar([0.3,0.3]), freqHi, rq, 1) * amploc};
Ndef(\sound2)[2] = \filter -> {|in, amp=0.8| ( in * amp)};
Ndef(\sound2)[3] = \filter -> {|in, lagTime=1, numCh=8, panCenter=2|
	var pan, out;
	pan = Lag.ar((Ndef(\cntrlGlob).ar * numCh - numCh / panCenter), lagTime);
	out = PanAz.ar(2, in, pan, 1, 2.0)};

)

//--

(
Ndef(\sound2comb).fadeTime = 20;
Ndef(\sound2comb)[0] = {|dtime1=0.02|CombC.ar(Ndef(\sound2).ar, 0.6, dtime1, 0.5)};
Ndef(\sound2comb)[1] = {|dtime2=0.004|CombC.ar(Ndef(\sound2).ar, 0.6, dtime2, 0.4)};
Ndef(\sound2comb)[2] = {|dtime3=0.007|CombC.ar(Ndef(\sound2).ar, 0.6, dtime3, 0.8)};
Ndef(\sound2comb)[3] = {|dtime4=0.01|CombC.ar(Ndef(\sound2).ar, 0.6, dtime4, 0.8)};
Ndef(\sound2comb)[4] = \filter -> {|in, amp=0.1| (in * amp)};
)



//__________


(

Ndef(\sound3).fadeTime = 10;

Ndef(\sound3)[0] =  {|amploc=0.8|FreeVerb.ar(RLPF.ar(LFDClipNoise.ar(Ndef(\cntrlscaled2).kr,0.1), 100, Ndef(\cntrlscaled1).kr, 0.3), 0.33, 0.5) * amploc ! 2};
Ndef(\sound3)[1] = {|amploc=0.8,freqHi=10000| RHPF.ar(LFDClipNoise.ar(Ndef(\cntrlscaled2).kr,0.1), freqHi, Ndef(\cntrlscaled1).kr, 1) * amploc ! 2};
Ndef(\sound3)[2] = \filter -> {|in, amp=1| ( in * amp)};
Ndef(\sound3)[3] = \filter -> {|in, lagTime=2, numCh=8, panCenter=2|
	var pan, out;
	pan = Lag.ar((Ndef(\cntrlGlob).ar * numCh - numCh / panCenter), lagTime);
	out = (PanAz.ar(2, in, pan, 1, 2.0))};
)


//__________

(

Ndef(\sound4).fadeTime = 10;

Ndef(\sound4)[0] = {|rq=0.05,amploc=0.4|RLPF.ar(LFDNoise3.ar(200,0.7), 80, rq, 0.3)  * amploc};
Ndef(\sound4)[1] =  {|rq=0.05,amploc=0.4|RHPF.ar(LFDNoise3.ar(200,0.7), 10000, rq, 1)  * amploc};
Ndef(\sound4)[2] = \filter -> { |in, amp=1| (in * amp)};
Ndef(\sound4)[3] = \filter -> {|in, lagTime=1, numCh=8, panCenter=2|
	var pan, out;
	pan = Lag.ar((Ndef(\cntrlGlob).ar * numCh - numCh / panCenter), lagTime);
	out = (PanAz.ar(2, in, pan, 1, 2.0))};
)

//___________

(

Ndef(\sound5).fadeTime = 10;
Ndef(\sound5)[0] =  {|amploc=0.8| RLPF.ar((SinOsc.ar([10, 20]).mod(LFNoise1.ar(100)) * 0.5 ), 80, 0.1, 0.3) * amploc};
Ndef(\sound5)[1] =  {|amploc=0.8, freqHi=10000| RHPF.ar((Saw.ar([10, 20]).mod(LFNoise1.ar(100)) * 0.5), freqHi, 0.05, 1) * amploc};
Ndef(\sound5)[2] = \filter -> { |in, amp=1| (in * amp)};
Ndef(\sound5)[3] = \filter -> {|in, lagTime=1, numCh=8, panCenter=2|
	var pan, out;
	pan = Lag.ar((Ndef(\cntrlGlob).ar * numCh - numCh / panCenter), lagTime);
	out = (PanAz.ar(2, in, pan, 1, 2.0))};

)

//___________

(

Ndef(\sound6).fadeTime = 6;

Ndef(\sound6)[1] = {|amploc=0.8,freqHi=8000, numharm=1000| RHPF.ar(GVerb.ar(in:Blip.ar(Ndef(\cntrlscaled3), numharm, 1.0), roomsize:2, revtime:TRand.kr(2, 8, Dust.kr(3)), drylevel:0.9), freqHi, 0.1, 0.1) * amploc};

Ndef(\sound6)[2] = {|amploc=0.8,freqHi=8000, delaytm=0.1, numharm=1000| RHPF.ar(GVerb.ar(in:DelayC.ar(Blip.ar(Ndef(\cntrlscaled3), numharm, 1.0), 10.0, delaytm), roomsize:1, revtime:TRand.kr(3, 8, Dust.kr(3)), drylevel:0.9), freqHi, 0.1, 0.1) * amploc};


Ndef(\sound6)[3] = \filter -> { |in, amp=0.8| (in * amp)};
Ndef(\sound6)[4] = \filter -> {|in, lagTime=1, numCh=8, panCenter=2|
	var pan, out;
	pan = Lag.ar((Ndef(\cntrlGlob).ar * numCh - numCh / panCenter), lagTime);
	out = (PanAz.ar(2, in, pan, 1, 2.0))};

)

(

Ndef(\sound7).fadeTime = 6;

Ndef(\sound7)[1] = {|amploc=0.8,freqHi=8000, numharm=1000| (RHPF.ar(GVerb.ar(in:Blip.ar(Ndef(\cntrlscaled4), numharm, 1.0), roomsize:2, revtime:TRand.kr(1, 2, Dust.kr(3)), drylevel:1.0), freqHi, 0.2, 0.1) * amploc)};

Ndef(\sound7)[2] = {|amploc=0.8,freqHi=8000, delaytm=0.1, numharm=1000| (RHPF.ar(GVerb.ar(in:DelayC.ar(Blip.ar(Ndef(\cntrlscaled4), numharm, 1.0), 10.0, delaytm), roomsize:1, revtime:TRand.kr(0.5, 2, Dust.kr(3)), drylevel:1.0), freqHi, 0.2, 0.1) * amploc)};


Ndef(\sound7)[3] = \filter -> { |in, amp=0.8| (in * amp)};
Ndef(\sound7)[4] = \filter -> {|in, lagTime=1, numCh=8, panCenter=2|
	var pan, out;
	pan = Lag.ar((Ndef(\cntrlGlob).ar * numCh - numCh / panCenter), lagTime);
	out = (PanAz.ar(2, in, pan, 1, 2.0))};

)

Ndef.clear



//------------- change parameters

(
Ndef(\cntrlGlob).set(\followerInputGain, 2.5);
Ndef(\cntrlPan).set(\followerInputGain, 1);
Ndef(\cntrlFlipped).set(\followerInputGain, 1);
Ndef(\cntrlOffset).set(\followerInputGain, 2);
Ndef(\cntrlscaled1).set(\followerInputGain, 2);
Ndef(\cntrlscaled2).set(\followerInputGain, 3);
Ndef(\cntrlscaled3).set(\followerInputGain, 3);
Ndef(\cntrlDelayed).set(\followerInputGain, 3);
Ndef(\cntrlInterrupted).set(\followerInputGain, 3);
)

(
Ndef(\cntrlGlob).set(\followerCut, 200);
Ndef(\cntrlPan).set(\followerCut, 200);
Ndef(\cntrlFlipped).set(\followerCut, 200);
Ndef(\cntrlOffset).set(\followerCut, 200);
Ndef(\cntrlscaled1).set(\followerCut, 200);
Ndef(\cntrlscaled2).set(\followerCut, 200);
Ndef(\cntrlscaled3).set(\followerCut, 200);
Ndef(\cntrlDelayed).set(\followerCut, 200);
Ndef(\cntrlInterrupted).set(\followerCut, 200);
)

(
Ndef(\cntrlscaled1).xset(\minscaled1, 0.01);   // rq of all filters + delay times comb filters
Ndef(\cntrlscaled1).xset(\maxscaled1, 0.3);
)

(
Ndef(\cntrlscaled2).xset(\minscaled2, 100);     //harmonics of impulses + freq sound3(LFDCLipNoise)
Ndef(\cntrlscaled2).xset(\maxscaled2, 100);
)
(
Ndef(\cntrlscaled3).xset(\minscaled3, 0.3);    // frequency of impulses of sound6
Ndef(\cntrlscaled3).xset(\maxscaled3, 0.4);
)
(
Ndef(\cntrlscaled4).xset(\minscaled4, 0.3);     // frequency of impulses of sound7
Ndef(\cntrlscaled4).xset(\maxscaled4, 2);
)

//_____________________

(
Ndef(\sound1).play(0,2);    //stereo tracks, routed to specific buses
Ndef(\sound1comb).play(0,2);
Ndef(\sound2).play(2,2);
Ndef(\sound2comb).play(2,2);
Ndef(\sound3).play(4,2);
Ndef(\sound4).play(6,2);
Ndef(\sound5).play(8,2);
Ndef(\sound6).play(10,2);
Ndef(\sound7).play(10,2);
)


Ndef.clear


// ------------------------------------play and change parameters----------------------------//


Ndef(\sound1).fadeTime = 10;
Ndef(\sound1).xset(\amploc, Ndef(\cntrlGlob));   //map ndef on LOCAL AMP
Ndef(\sound1).xset(\amploc, 0.9);                             //unmap ndef on LOCAL AMP
Ndef(\sound1).xset(\amp, Ndef(\cntrlGlob));       //map ndef on GLOBAL AMP
Ndef(\sound1).xset(\amp, 0.9);                                  //unmap ndef on GLOBAL AMP
Ndef(\sound1).xset(\freqHi, 8000);
Ndef(\sound1).xset(\rq, 0.5);
Ndef(\sound1).xset(\rq, Ndef(\cntrlscaled1));

Ndef(\sound1).stop(3)

Ndef(\sound1comb).xset(\amp, 0.0);    //dry-wet comb

Ndef(\sound1comb).xset(\dtime1, Ndef(\cntrlscaled1));
Ndef(\sound1comb).xset(\dtime1, 0.01);
Ndef(\sound1comb).xset(\dtime1, Ndef(\controlComb1));
Ndef(\sound1comb).xset(\dtime2, Ndef(\cntrlscaled1));
Ndef(\sound1comb).xset(\dtime2, 0.005);
Ndef(\sound1comb).xset(\dtime2, Ndef(\controlComb2));
Ndef(\sound1comb).xset(\dtime3, Ndef(\cntrlscaled1));
Ndef(\sound1comb).xset(\dtime3, 0.008);
Ndef(\sound1comb).xset(\dtime3, Ndef(\controlComb3));
Ndef(\sound1comb).xset(\dtime4, Ndef(\cntrlscaled1));
Ndef(\sound1comb).xset(\dtime4, 0.5);
Ndef(\sound1comb).xset(\dtime3, Ndef(\controlComb4));

Ndef(\cntrlGlob).clear(20)


Ndef(\sound2).fadeTime = 6;
Ndef(\sound2).xset(\amploc, Ndef(\cntrlGlob)); //map ndef on LOCAL AMP
Ndef(\sound2).xset(\amploc, 0.9);                          //unmap ndef on LOCAL AMP
Ndef(\sound2).xset(\amp, Ndef(\cntrlGlob));   //map ndef on GLOBAL AMP
Ndef(\sound2).xset(\amp, 0.9);                              //unmap ndef on GOBAL AMP
Ndef(\sound2).xset(\freqHi, 5000);
Ndef(\sound2).xset(\rq, 0.5);
Ndef(\sound2).xset(\rq, Ndef(\cntrlscaled1));  //map ndef on rq factors

Ndef(\sound2).stop(3)

Ndef(\sound2comb).xset(\amp, 0.0);  //dry-wet comb

Ndef(\sound2comb).xset(\dtime1, Ndef(\cntrlscaled1));
Ndef(\sound2comb).xset(\dtime1, 0.002);
Ndef(\sound2comb).xset(\dtime2, Ndef(\cntrlscaled1));
Ndef(\sound2comb).xset(\dtime2, 0.004);
Ndef(\sound2comb).xset(\dtime3, Ndef(\cntrlscaled1));
Ndef(\sound2comb).xset(\dtime3, 0.007);
Ndef(\sound2comb).xset(\dtime4, Ndef(\cntrlscaled1));
Ndef(\sound2comb).xset(\dtime4, 0.01);



Ndef(\sound3).fadeTime = 6;
Ndef(\sound3).xset(\amploc, Ndef(\cntrlGlob)); //map ndef on LOCAL AMP
Ndef(\sound3).xset(\amploc, 1.0);                                 //unmap ndef on LOCAL AMP
Ndef(\sound3).xset(\amp, Ndef(\cntrlGlob));   //map ndef on GLOBAL AMP
Ndef(\sound3).xset(\amp, 1.0);                                  //unmap ndef   on GLOBAL AMP
Ndef(\sound3).xset(\freqHi, 3000);

Ndef(\sound3).stop(10)

Ndef(\sound4).fadeTime = 3;
Ndef(\sound4).xset(\amploc, Ndef(\cntrlGlob)); //map ndef on LOCAL  AMP
Ndef(\sound4).xset(\amploc, 0.8);                            //unmap ndef on LOCAL AMP
Ndef(\sound4).xset(\amp, Ndef(\cntrlGlob));  //map ndef on GLOBAL AMP
Ndef(\sound4).xset(\amp, 0.1);                              //unmap ndef on GOBAL AMP
Ndef(\sound4).xset(\rq, 0.5);

Ndef(\sound4).stop(5)


Ndef(\sound5).fadeTime = 6;
Ndef(\sound5).xset(\amploc, Ndef(\cntrlGlob));   // map ndef on LOCAL AMP
Ndef(\sound5).xset(\amploc, 0.9);                                   // unmap ndef on LOCAL AMP
Ndef(\sound5).xset(\amp, Ndef(\cntrlGlob));  //map ndef on GLOBAL AMP
Ndef(\sound5).xset(\amp, 0.89);                                     //unmap ndef on GLOBAL AMP
Ndef(\sound5).xset(\freqHi, 10000);

Ndef(\sound5).stop(20)


Ndef(\sound6).fadeTime = 2;
Ndef(\sound6).xset(\amploc, Ndef(\cntrlInterrupted));  //map ndef on LOCAL AMP
Ndef(\sound6).xset(\amploc, 0.88);                                        //unmap ndef on LOCAL AMP
Ndef(\sound6).xset(\amp, Ndef(\cntrlInterrupted));   //map ndef on GLOBAL AMP
Ndef(\sound6).xset(\amp, 0.88);                                           //unmap ndef on GLOBAL AMP
Ndef(\sound6).xset(\freqHi, 100);
Ndef(\sound6).xset(\numharm, Ndef(\cntrlscaled2));
Ndef(\sound6).xset(\delaytm, 0.1);

Ndef(\sound6).stop(1)



Ndef(\sound7).fadeTime = 2;
Ndef(\sound7).xset(\amploc, Ndef(\cntrlInterrupted));  //map ndef on LOCAL AMP
Ndef(\sound7).xset(\amploc, 0.88);                                        //unmap ndef on LOCAL AMP
Ndef(\sound7).xset(\amp, Ndef(\cntrlInterrupted));   //map ndef on GLOBAL AMP
Ndef(\sound7).xset(\amp, 0.88);                                           //unmap ndef on GLOBAL AMP
Ndef(\sound7).xset(\freqHi, 150);
Ndef(\sound7).xset(\numharm, Ndef(\cntrlscaled2));
Ndef(\sound7).xset(\delaytm, 0.1);

Ndef(\sound7).stop(30)

Ndef.clear

