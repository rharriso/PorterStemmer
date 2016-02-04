module porter_stemmer;

import std.typecons;
import std.string;
import std.array;
import std.stdio;

string stem(T)(in T inS){
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


/*
  Returns true if the letter at
  the passed index is a vowel
*/
bool isVowel(T)(in T word, int index){
  switch(word[index]){
    case 'a':
    case 'A':
    case 'e':
    case 'E':
    case 'i':
    case 'I':
    case 'o':
    case 'O':
    case 'u':
    case 'U':
        return true;
    case 'y':
    case 'Y':
        return index > 0 && !isVowel(word, index-1);
    default:
        return false;

  } 
}


unittest {
    // cases are just pairs onf expected outputs
    auto cases = [
        // 1a
        tuple("caresses", "caress"),
        tuple("ties", "ti"),
        tuple("cats", "cat"),
        tuple("ponies", "poni"),
    ];

    foreach(c; cases){
        assert(stem(c[0]) == c[1],
            "Expected '"~c[0]~"'to stem to '"~c[1]~"'");
    }
}

unittest {
    auto cases = [
      tuple("caresses", 0, false),
      tuple("caresses", 1, true),
      tuple("caresses", 3, true),
      tuple("caresses", 4, false),
      tuple("caresses", 6, true),
      tuple("cray", 3, false),
      tuple("try", 2, true),
      tuple("yak", 0, false)
    ];

    foreach(c; cases){
      auto msg = c[2] ? "Expected '"~c[0][c[1]]~"' in '"~c[0]~"' to be a vowel " :
                        "Expected '"~c[0][c[1]]~"' in '"~c[0]~"' not to be a vowel ";
      assert(isVowel(c[0], c[1]) == c[2], msg);
    }

}

