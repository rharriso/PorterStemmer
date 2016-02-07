module porter_stemmer;

import std.typecons;
import std.string;
import std.array;
import std.stdio;

string stem(T)(in T inS)
{
    string s = inS.toLower();
    auto mc = measure(inS);

    step1ab(s);

    return s;
}

void step1ab(T)(ref T s){
    //step 1a
    if (s.length > 4 && s[$ - 4 .. $] == "sses")
    {
        s.length -= 2;
        replaceInPlace(s, s.length - 2, s.length, "ss");
    }
    else if (s.length > 3 && s[$ - 3 .. $] == "ies")
    {
        s.length -= 2;
        replaceInPlace(s, s.length - 1, s.length, "i");
    }
    else if (s.length > 2 && s[$ - 2 .. $] == "ss")
    {
    }
    else if (s.length > 1 && s[$ - 1 .. $] == "s")
    {
        s.length--;
    }

    //step 1b
    if (s.length > 3 && s[$ - 3 .. $] == "eed")
    {
        if (measure(s, 4) > 0)
        {
            s.length--;
        }
    }

    else if (s.length > 2 && s[$ - 2 .. $] == "ed" && containsVowel(s[0 .. $ - 2]))
    {

        s.length -= 2;
    }
    else if (s.length > 3 && s[$ - 3 .. $] == "ing" && containsVowel(s[0 .. $ - 3]))
    {
        s.length -= 3;
    }

}

/*
  returns the mcount for the given word
*/
int measure(T)(in T word, int offset = 0)
{
    int m = 0;
    auto isV = isVowel(word, 0);
    auto len = long(word.length) - offset;

    for (int i = 1; i < len; i++)
    {
        auto newV = isVowel(word, i);

        // count up the number of vowel sets found
        if (!newV && isV)
        {
            m++;
        }

        isV = newV;
    }

    return m;
}

/*
  returns true if the passes string contains a vowel
*/
bool containsVowel(T)(in T word)
{
    for (auto i = 0; i < word.length; i++)
    {
        if (isVowel(word, i))
        {
            return true;
        }
    }
    return false;
}

/*
  Returns true if the letter at
  the passed index is a vowel
*/
bool isVowel(T)(in T word, int index)
{
    switch (word[index])
    {
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
        return index > 0 && !isVowel(word, index - 1);
    default:
        return false;

    }
}

/*
  returns true if the word ends with 
 */

/*
   stemStes
 */
unittest
{
    // cases are just pairs onf expected outputs
    auto cases = [
        tuple("caresses", "caress"), tuple("ties", "ti"), tuple("cats", "cat"),
        tuple("ponies", "poni"),//1b
        tuple("feed", "feed"), tuple("agreed",
        "agree"), tuple("plastered", "plaster"), tuple("bled", "bled"),
        tuple("motoring", "motor"), tuple("sing", "sing"),
    ];

    foreach (c; cases)
    {
        assert(stem(c[0]) == c[1],
            "Expected '" ~ c[0] ~ "' to stem to '" ~ c[1] ~ "' got '" ~ stem(c[0]) ~ "'");
    }
}

/*
  measure tests
 */
unittest
{
    import std.conv;

    auto cases = [tuple("tr", 0), tuple("ee", 0), tuple("feed", 1),
        tuple("tree", 0), tuple("y", 0), tuple("by", 0), tuple("trouble", 1),
        tuple("oats", 1), tuple("trees", 1), tuple("ivy", 1), tuple("troubles",
        2), tuple("private", 2), tuple("oaten", 2), tuple("orrery", 2),];

    foreach (c; cases)
    {
        assert(measure(c[0]) == c[1],
            "Expected '" ~ c[0] ~ "' to have an mcount '" ~ to!(string)(c[1]) ~ "' got '" ~ to!(
            string)(measure(c[0])) ~ "'");

    }
}

/*
  containsVowelTests
 */
unittest
{
    auto cases = [
        tuple("aa", true), tuple("ba", true), tuple("bb", false), tuple("by",
        true), tuple("yy", true), tuple("happy", true), tuple("cpp", false)
    ];

    foreach (c; cases)
    {
        auto phrase = c[1] ? "to contain a vowel" : "not to contain a vowel";
        assert(containsVowel(c[0]) == c[1], "Expected '" ~ c[0] ~ "' " ~ phrase);
    }
}

/*
  isVowelTests
 */
unittest
{
    auto cases = [
        tuple("caresses", 0, false), tuple("caresses", 1, true),
        tuple("caresses", 3, true), tuple("caresses", 4, false),
        tuple("caresses", 6, true), tuple("cray", 3, false), tuple("try", 2,
        true), tuple("yak", 0, false)
    ];

    foreach (c; cases)
    {
        auto msg = c[2] ? "Expected '" ~ c[0][c[1]] ~ "' in '" ~ c[0] ~ "' to be a vowel "
            : "Expected '" ~ c[0][c[1]] ~ "' in '" ~ c[0] ~ "' not to be a vowel ";
        assert(isVowel(c[0], c[1]) == c[2], msg);
    }

}
