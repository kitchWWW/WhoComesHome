[4,//a #major third
0,//b
2,//c
11,//d
12,//e #1
14,//f
14,//g
28,//h
19,//i
7,//j
0,//k
23,//l
0,//m
19,//n
16,//o #4
33,//p
0,//q
31,//r
36,//s
24,//t  #2
2,//u
0,//v
1,//w
0,//x
0,//y
0//z
] @=> int alpha[];

[0,2,4,5,7,9]@=> int scale[];

for( 0 => int foo; foo < 26 ; foo++ )
{
    // debug-print value of 'foo' 
    (12*Math.random2(4,6))+scale[Math.random2(0,5)] @=> alpha[foo];
    <<<scale[Math.random2(0,5)]>>>;
}


// HID
Hid hi;
HidMsg msg;

// which keyboard
0 => int device;
// get from command line
if( me.args() ) me.arg(0) => Std.atoi => device;

// open keyboard (get device number from command line)
if( !hi.openKeyboard( device ) ) me.exit();
<<< "keyboard '" + hi.name() + "' ready", "" >>>;

// patch



Wurley voc => Echo a => a => JCRev r => dac;
voc => dac;

// initial settings
220.0 => voc.freq;
0.95 => voc.gain;
.8 => r.gain;
.1 => r.mix;
5::second => a.max;
500::ms => a.delay;
.98 => a.mix;



[15,15,15,25,25] @=>int keys[];
0 => int keyIndex;
15 => int key; //E or something cool like that I think

.6=> float eT;
//.3=> float e2T;
.6=> float eCur;
//.3=> float e2Cur;

//spork ~ fadeNice();

// infinite event loop
while( true )
{
    // wait for event
    hi => now;
    // get message
    while( hi.recv( msg ) )
    {
        // check
        if( msg.isButtonDown() )
        {
            0 => float freq;
            <<<msg.which>>>;
            
            if(msg.which < 30){
                //we are alpha character
                Std.mtof(alpha[msg.which-4]+key) => freq;
            }else if(msg.which==44){
                //this one should be the space key!
                Std.mtof(key-12) => freq;
            }else if(msg.which==40){
                //Enter key I think?
                //keyIndex++;
                keys[keyIndex%5]=>key;
            }else if(msg.which == 229){
                //shift
                1 => eT;
            }else if(msg.which == 55){
                // period
                spork ~ punctuate(key,0);
            }else if(msg.which == 56){
                // ?
                spork ~ punctuate(key,1);
            }else if(msg.which == 30){
                //!
                spork ~ punctuate(key, 2);
            }else if(msg.which == 54){
                //,
                spork ~ punctuate(key, 3);
            }else if(msg.which == 31){
                //THE NUMBER 2
                 .1 => a.mix;
            }
            else if(msg.which == 32){
                //THE NUMBER 3
                .3 => a.mix;
            }else if(msg.which == 33){
                //THE NUMBER 4
                .98 => a.mix;
            }else if(msg.which == 36){
                //THE NUMBER 7
                250::ms => a.delay;
            }
            else if(msg.which == 37){
                //THE NUMBER 8
                500::ms => a.delay;
            }else if(msg.which == 38){
                //THE NUMBER 9
                1.25::second => a.delay;
            }
            if(freq!=0){
                freq => voc.freq;
                1 => voc.gain;
                1 => voc.noteOn;
                80::ms => now; 
            }
            
        }
        else
        {
            if(msg.isButtonUp() && (msg.which == 229)){
                .6 => eT;
                //.3 => e2T;
                <<<msg.which>>>;
            }else{
                0 => voc.noteOff;
            }
        }
    }
}

fun void punctuate(int thisKey, int style)
{
    // 0 -> .
    // 1 -> ?
    // 2 -> ! (1)
    // 3 -> ,
}
