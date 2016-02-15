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
  auto r = regex(r"[^\w]+");

  auto tokens = split(txt, r);
  string[] stems;

  void f0()
  {
    import core.memory;
    GC.disable;
    auto app = appender(&stems);
    foreach(token; tokens)
      app ~= stem(token);
    writeln("Cycle completed...");
    GC.enable;
    GC.collect;
  }

  writeln("\nRunning Benchmark...\n");
  int cycles = 10;
  auto res = benchmark!f0(cycles);
  writeln("Stemmed 'De Bello Gallico' ", cycles, " times in ", res[0].msecs(), " milliseconds");
  writeln(double(res[0].nsecs()) / (10^^9 * cycles), " seconds per pass");
  writeln("\nCompleted Benchmark\n");

  auto outFileName = "./test/stemmed-bello-gallico.txt";
  File(outFileName).write(stems.joiner("\n"));
  writeln("Wrote stems to: ", outFileName, "\n");
}

