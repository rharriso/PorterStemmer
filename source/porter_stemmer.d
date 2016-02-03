module porter_stemmer;

import std.typecons;

string stem(in string s){
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
