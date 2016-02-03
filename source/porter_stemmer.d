module porter_stemmer;

import std.typecons;
import std.string;
import std.array;

string stem(in string inS){
    string s = inS.toLower();

    //step 1a
    if(s[$-4..$] == "sses"){
        s.length -= 2;
        replaceInPlace(s, s.length-2, s.length, "ss");
    } else if(s[$-3..$] == "ies"){
        s.length -= 2;
        replaceInPlace(s, s.length-1, s.length, "i");
    } else if(s[$-2..$] == "ss"){
    } else if(s[$-1..$] == "s"){
        s.length --;
    }

    return s;


}

unittest {
    // cases are just pairs onf expected outputs
    auto cases = [
        tuple("caresses", "caress"),
        tuple("ties", "ti"),
        tuple("cats", "cat"),
        tuple("ponies", "poni")
    ];

    foreach(c; cases){
        assert(stem(c[0]) == c[1],
            "Expected '"~c[0]~"'to stem to '"~c[1]~"'");
    }
}
