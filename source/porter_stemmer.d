module porter_stemmer;

import std.typecons;
import std.string;
import std.array;
import std.stdio;

string stem(T)(in T inS)
{
  string s = inS.toLower();
  auto mc = measure(inS);

  step1(s);
  step2(s);
  step3(s);
  step4(s);
  step5(s);

  return s;
}

/*
   Apply step 1 a, b and c to passed string
 */
void step1(T)(ref T s)
{
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
    step1b2(s);
  }
  else if (s.length > 3 && s[$ - 3 .. $] == "ing" && containsVowel(s[0 .. $ - 3]))
  {
    s.length -= 3;
    step1b2(s);
  }

  //step1c
  if (s[$ - 1] == 'y' && containsVowel(s[0 .. $ - 1]))
  {
    replaceInPlace(s, s.length - 1, s.length, "i");
  }
}

/*
   apply second half of step b to string
 */
void step1b2(T)(ref T s)
{
  auto tail = s[$ - 2 .. $];

  if (s.length > 2 && tail == "at" || tail == "iz" || tail == "bl")
  {

    s ~= "e";
  }

  else if (!isVowel(tail, 0) && !isVowel(tail, 1) && !(tail[1] == 'l'
      || tail[1] == 's' || tail[1] == 'z'))
  {
    s.length--;
  }

  else if (measure(s) == 1 && !isVowel(s, s.length - 3) && isVowel(s,
      s.length - 2) && !isVowel(s, s.length - 1))
  {
    s ~= "e";
  }
}

/*
  Apply step2
 */
void step2(T)(ref T s)
{
  auto mappings = [
    tuple("ational", "ate"),
    tuple("tional", "tion"),
    tuple("enci", "ence"),
    tuple("anci", "ance"),
    tuple("izer", "ize"),
    tuple("abli", "able"),
    tuple("alli", "al"),
    tuple("entli", "ent"),
    tuple("eli", "e"),
    tuple("ousli", "ous"),
    tuple("ization", "ize"),
    tuple("ation", "ate"),
    tuple("ator", "ate"),
    tuple("alism", "al"),
    tuple("iveness", "ive"),
    tuple("fulness", "ful"),
    tuple("ousness", "ous"),
    tuple("aliti", "al"),
    tuple("iviti", "ive"),
    tuple("biliti", "ble"),
  ];

  applyMapping(s, mappings);
}

/*
   apply step
 */
void step3(T)(ref T s){
  auto mappings = [
    tuple("icate", "ic"),
    tuple("ative", ""),
    tuple("alize", "al"),
    tuple("iciti", "ic"),
    tuple("ical", "ic"),
    tuple("ful", ""),
    tuple("ness", ""),
   ];

  applyMapping(s, mappings);
}

/*
   apply step4
 */
void step4(T)(ref T s)
{
  auto mappings = [
    tuple("al", ""),
    tuple("ance", ""),
    tuple("ence", ""),
    tuple("er", ""),
    tuple("ic", ""),
    tuple("able", ""),
    tuple("ible", ""),
    tuple("ant", ""),
    tuple("ement", ""),
    tuple("ment", ""),
    tuple("ent", ""),
    tuple("tion", ""),
    tuple("sion", ""),
    tuple("ou", ""),
    tuple("ism", ""),
    tuple("ate", ""),
    tuple("iti", ""),
    tuple("ous", ""),
    tuple("ive", ""),
    tuple("ize", ""),
  ];

  applyMapping(s, mappings, 2);
}

/*
  step5a
 */
void step5(T)(ref T s){
  // 5a
  auto mappings = [
    tuple("e", ""),
  ]; 
  applyMapping(s, mappings, 2);

  if(!starO(s[0 .. $-1])){
    applyMapping(s, mappings, 1);
  }

  // 5b
}

/*
 applyMappings applies the appropriate map to the passed string,
 and checks a minumum measure
 */
void applyMapping(T)(ref T s, Tuple!(string, string)[] mappings, ulong minMeasure = 1)
{
  foreach (m; mappings)
  {
    if (s.length <= m[0].length || measure(s, m[0].length) < minMeasure)
      continue;

    if (s[$ - m[0].length .. $] == m[0])
    {
      s.length -= m[0].length;
      s ~= m[1];
      return;
    }
  }

}

/*
   returns the mcount for the given word
 */
ulong measure(T)(in T word, ulong offset = 0)
{
  ulong m = 0;
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
bool isVowel(T)(in T word, ulong index)
{
  if (index >= word.length)
  {
    return false;
  }

  switch (word[index])
  {
  case 'a', 'e', 'i', 'o', 'u':
    return true;
  case 'y':
    return index > 0 && !isVowel(word, index - 1);
  default:
    return false;
  }
}

/*
   returns true if the word ends with  cvc and the second
   c is not w,x,y
 */
bool starO(T)(in T word){
  if (word.length >= 3 &&
      !isVowel(word, word.length - 3) &&
      isVowel(word, word.length - 2) &&
      !isVowel(word, word.length - 1)){

    auto c = word[$-1];
    return c != 'w' && c != 'x' && c != 'y';
  }

  return false;
}

/*
   stemStes
 */
unittest
{
  // cases are just pairs onf expected outputs
  auto cases = [
    tuple("caresses", "caress"),
    tuple("ties", "ti"),
    tuple("cats", "cat"),
    tuple("ponies", "poni"),
    //1b
    tuple("feed", "feed"),
    tuple("agreed", "agre"),
    tuple("plastered", "plaster"),
    tuple("bled", "bled"),
    tuple("motoring", "motor"),
    tuple("sing", "sing"),
    //1b2
    tuple("conflated", "conflat"),
    tuple("troubled", "troubl"),
    tuple("sized", "size"),
    tuple("hopping", "hop"),
    tuple("tanned", "tan"),
    tuple("falling", "fall"),
    tuple("hissing", "hiss"),
    tuple("fizzed", "fizz"),
    tuple("failing", "fail"),
    tuple("filing", "file"),
    //1c
    tuple("happy", "happi"),
    tuple("sky", "sky"),
    // 2
    tuple("relational", "relat"),
    tuple("conditional", "condition"),
    tuple("rational", "ration"),
    tuple("valenci", "valenc"),
    tuple("hesitanci", "hesit"),
    tuple("digitizer", "digit"),
    tuple("conformabli", "conform"),
    tuple("radicalli", "radic"),
    tuple("differentli", "differ"),
    tuple("vileli", "vile"),
    tuple("analogousli", "analog"),
    tuple("vietnamization", "vietnam"),
    tuple("predication", "predic"),
    tuple("operator", "oper"),
    tuple("feudalism", "feudal"),
    tuple("decisiveness", "decis"),
    tuple("hopefulness", "hope"),
    tuple("callousness", "callous"),
    tuple("formaliti", "formal"),
    tuple("sensitiviti", "sensit"),
    tuple("sensibiliti", "sensibl"),
    // 3
    tuple("triplicate", "triplic"),
    tuple("formative", "form"),
    tuple("formalize", "formal"),
    tuple("electriciti", "electr"),
    tuple("hopeful", "hope"),
    tuple("goodness", "good"),

    // 4
    tuple("revival", "reviv"),
    tuple("allowance", "allow"),
    tuple("inference", "infer"),
    tuple("airliner", "airlin"),
    tuple("gyroscopic", "gyroscop"),
    tuple("adjustable", "adjust"),
    tuple("defensible", "defens"),
    tuple("irritant", "irrit"),
    tuple("replacement", "replac"),
    tuple("adjustment", "adjust"),
    tuple("dependent", "depend"),
    tuple("adoption", "adop"),
    tuple("homologou", "homolog"),
    tuple("communism", "commun"),
    tuple("activate", "activ"),
    tuple("angulariti", "angular"),
    tuple("homologous", "homolog"),
    tuple("effective", "effect"),
    tuple("bowdlerize", "bowdler"),

    // 5a
    tuple("probate", "probat"),
    tuple("rate", "rate"),
    // 5b
    tuple("cease", "ceas"),
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

  auto cases = [
    tuple("tr", 0),
    tuple("ee", 0),
    tuple("feed", 1),
    tuple("tree", 0),
    tuple("y", 0),
    tuple("by", 0),
    tuple("trouble", 1),
    tuple("oats", 1),
    tuple("trees", 1),
    tuple("ivy", 1),
    tuple("troubles", 2),
    tuple("private", 2),
    tuple("oaten", 2),
    tuple("orrery", 2)
  ];

  foreach (c; cases)
  {
    assert(measure(c[0]) == c[1],
      "Expected '" ~ c[0] ~ "' to have an mcount '" ~ to!(string)(c[1]) ~ "' got '" ~ to!(string)(
      measure(c[0])) ~ "'");

  }
}

/*
   containsVowelTests
 */
unittest
{
  auto cases = [
    tuple("aa", true),
    tuple("ba", true),
    tuple("bb", false),
    tuple("by", true),
    tuple("yy", true),
    tuple("happy", true),
    tuple("cpp", false)
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
    tuple("caresses", 0, false),
    tuple("caresses", 1, true),
    tuple("caresses", 3, true),
    tuple("caresses", 4, false),
    tuple("caresses", 6, true),
    tuple("cray", 3, false),
    tuple("try", 2, true),
    tuple("yak", 0, false)
  ];

  foreach (c; cases)
  {
    auto msg = c[2] ?
      "Expected '" ~ c[0][c[1]] ~ "' in '" ~ c[0] ~ "' to be a vowel " :
      "Expected '" ~ c[0][c[1]] ~ "' in '" ~ c[0] ~ "' not to be a vowel ";
    assert(isVowel(c[0], c[1]) == c[2], msg);
  }

}

/*
  starO tests
 */
unittest
{
  auto cases = [
    tuple("wow", false),
    tuple("wil", true),
    tuple("hop", true),
  ];

  foreach (c; cases)
  {
    auto msg = c[1] ?
      "Expected starO '" ~ c[0]~ "' to be true" :
      "Expected starO '" ~ c[0]~ "' to be false";
    assert(starO(c[0]) == c[1], msg);
  }

}
