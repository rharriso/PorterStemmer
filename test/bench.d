/**
 Benchmarks and compare with python
 */

import std.file : readText;
import std.regex;
import std.datetime;
import std.conv : to;
import std.stdio;
import std.algorithm;
import std.array;

import porter_stemmer;

void main()
{
  auto txt = readText("./test/de-bello-gallico.txt"); // assume running text from project root
  static r = ctRegex!(r"[^\w]+");

  auto tokens = split(txt, r);
  auto stems = new typeof(tokens)(tokens.length);

  void f0()
  {
    tokens.map!stem.copy(stems);
    writeln("Cycle completed...");
  }

  writeln("\nRunning Benchmark...\n");
  int cycles = 20;
  auto res = benchmark!f0(cycles);
  writeln("Stemmed 'De Bello Gallico' ", cycles, " times in ", res[0].msecs(), " milliseconds");
  writeln(double(res[0].nsecs()) / (10.0^^9 * cycles), " seconds per pass");
  writeln("\nCompleted Benchmark\n");

  auto outFileName = "./test/stemmed-bello-gallico.txt";
  File(outFileName).write(stems.joiner("\n"));
  writeln("Wrote stems to: ", outFileName, "\n");
}

