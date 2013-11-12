-module(translate_rna).
-export([start/1]).

start(N)->
  {ok,Data} = file:read_file(N),
  D = re:replace(Data,"$<<","",[global,{return,list}]),
  %T = string:tokens(D,"\n"),
  %io:format("~w\n",[T]),
  io:format("~s\n",[translator(D,[])]).
  %translator(N,[]).

translator(N,X)->
  T = iolist_size(N),
  if
    N == [] -> X;
    T < 3 -> X;
    X == [] -> translator(lists:nthtail(3,N),[translate(lists:sublist(N,3))]);
    
    1 == 1 ->translator(lists:nthtail(3,N),X ++ [translate(lists:sublist(N,3))])
  end.

translate(N)->
  if
      N == "UUU" -> "F";
      N == "CUU" -> "L";
      N == "AUU" -> "I";
      N == "GUU" -> "V";

      N == "UUC" -> "F";
      N == "CUC" -> "L";
      N == "AUC" -> "I";
      N == "GUC" -> "V";

N == "UUA" -> "L";
      N == "CUA" -> "L";
      N == "AUA" -> "I";
      N == "GUA" -> "V";

N == "UUG" -> "L";
      N == "CUG" -> "L";
      N == "AUG" -> "M";
      N == "GUG" -> "V";

N == "UCU" -> "S";
      N == "CCU" -> "P";
      N == "ACU" -> "T";
      N == "GCU" -> "A";

N == "UCC" -> "S";
      N == "CCC" -> "P";
      N == "ACC" -> "T";
      N == "GCC" -> "A";

N == "UCA" -> "S";
      N == "CCA" -> "P";
      N == "ACA" -> "T";
      N == "GCA" -> "A";

N == "UCG" -> "S";
      N == "CCG" -> "P";
      N == "ACG" -> "T";
      N == "GCG" -> "A";

N == "UAU" -> "Y";
      N == "CAU" -> "H";
      N == "AAU" -> "N";
      N == "GAU" -> "D";

N == "UAC" -> "Y";
      N == "CAC" -> "H";
      N == "AAC" -> "N";
      N == "GAC" -> "D";

N == "UAA" -> "Stop";
   N == "CAA" -> "Q";
      N == "AAA" -> "K";
      N == "GAA" -> "E";

N == "UAG" -> "Stop";
   N == "CAG" -> "Q";
      N == "AAG" -> "K";
      N == "GAG" -> "E";

N == "UGU" -> "C";
      N == "CGU" -> "R";
      N == "AGU" -> "S";
      N == "GGU" -> "G";

N == "UGC" -> "C";
      N == "CGC" -> "R";
      N == "AGC" -> "S";
      N == "GGC" -> "G";

N == "UGA" -> "Stop";
   N == "CGA" -> "R";
      N == "AGA" -> "R";
      N == "GGA" -> "G";

N == "UGG" -> "W";
      N == "CGG" -> "R";
      N == "AGG" -> "R";
      N == "GGG" -> "G";
 1 == 1 -> 0
end.
