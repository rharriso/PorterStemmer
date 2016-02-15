import std.file;
import std.regex;
import std.datetime;
import std.conv : to;
import std.stdio;

import porter_stemmer;

void main()
{
  auto txt = readText("./test/de-bello-gallico.txt"); // assume running text from project root
  auto r = regex(r"[^\w]+");

  auto tokens = split(txt, r);
  string[] stems;

  void f1 (){
    stems = [];
    foreach(t; tokens){
      stems ~= stem(t);
    }
    writeln("Cycle completed...");
  }

  writeln("\nRunning Benchmark...\n");
  int cycles = 10;
  auto res = benchmark!(f1)(cycles);
  writeln("Stemmed 'De Bello Gallico' ", cycles, " times in ", res[0].msecs(), " milliseconds");
  writeln(to!(double)(res[0].seconds()) / cycles, " seconds per pass");
  writeln("\nCompleted Benchmark\n");

  auto outFileName = "./test/stemmed-bello-gallico.txt";
  if(exists(outFileName)){
    remove(outFileName);
  }
  foreach(s; stems){
    append(outFileName, s);
    append(outFileName, "\n");
  }
  writeln("Wrote stems to: ", outFileName, "\n");
}

