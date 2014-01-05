-module(helpers).
-export([
    make_permutations/1,
    make_compliment/1,
    translate_dna_rna/1,
    translate_rna_prot/1,
    make_reverse_compliment/1,
    find_all_pos/4,
    fetch_web/1,
    fetch_uniprot/1,
    get_protein_weight/1,
    get_mrna_prot_lookup/0,
    index_of/2,
    hamming_distance/2
  ]).

-define(UniProtPrefix, "http://www.uniprot.org/uniprot/").
-define(UniProtPostfix, ".fasta").

-define(ProteinWeightLookup,
  dict:from_list( [
      { hd("A") , 71.03711 },
      { hd("C") , 103.00919 },
      { hd("D") , 115.02694 },
      { hd("E") , 129.04259 },
      { hd("F") , 147.06841 },
      { hd("G") , 57.02146 },
      { hd("H") , 137.05891 },
      { hd("I") , 113.08406 },
      { hd("K") , 128.09496 },
      { hd("L") , 113.08406 },
      { hd("M") , 131.04049 },
      { hd("N") , 114.04293 },
      { hd("P") , 97.05276 },
      { hd("Q") , 128.05858 },
      { hd("R") , 156.10111 },
      { hd("S") , 87.03203 },
      { hd("T") , 101.04768 },
      { hd("V") , 99.06841 },
      { hd("W") , 186.07931 },
      { hd("Y") , 163.06333 }
]
  )).

-define(MrnaProtLookup,
  dict:from_list( [

{ "UUU" , "F" },  
{ "CUU" , "L" },  
{ "AUU" , "I" },  
{ "GUU" , "V" },  
{ "UUC" , "F" },  
{ "CUC" , "L" },  
{ "AUC" , "I" },  
{ "GUC" , "V" },  
{ "UUA" , "L" },  
{ "CUA" , "L" },  
{ "AUA" , "I" },  
{ "GUA" , "V" },  
{ "UUG" , "L" },  
{ "CUG" , "L" },  
{ "AUG" , "M" },  
{ "GUG" , "V" },  
{ "UCU" , "S" },  
{ "CCU" , "P" },  
{ "ACU" , "T" },  
{ "GCU" , "A" },  
{ "UCC" , "S" },  
{ "CCC" , "P" },  
{ "ACC" , "T" },  
{ "GCC" , "A" },  
{ "UCA" , "S" },  
{ "CCA" , "P" },  
{ "ACA" , "T" },  
{ "GCA" , "A" },  
{ "UCG" , "S" },  
{ "CCG" , "P" },  
{ "ACG" , "T" },  
{ "GCG" , "A" },  
{ "UAU" , "Y" },  
{ "CAU" , "H" },  
{ "AAU" , "N" },  
{ "GAU" , "D" },  
{ "UAC" , "Y" },  
{ "CAC" , "H" },  
{ "AAC" , "N" },  
{ "GAC" , "D" },  
{ "UAA" , "Stop" },  
{ "CAA" , "Q" },  
{ "AAA" , "K" },  
{ "GAA" , "E" },  
{ "UAG" , "Stop" },  
{ "CAG" , "Q" },  
{ "AAG" , "K" },  
{ "GAG" , "E" },  
{ "UGU" , "C" },  
{ "CGU" , "R" },  
{ "AGU" , "S" },  
{ "GGU" , "G" },  
{ "UGC" , "C" },  
{ "CGC" , "R" },  
{ "AGC" , "S" },  
{ "GGC" , "G" },  
{ "UGA" , "Stop" },  
{ "CGA" , "R" },  
{ "AGA" , "R" },  
{ "GGA" , "G" },  
{ "UGG" , "W" },  
{ "CGG" , "R" },  
{ "AGG" , "R" },  
{ "GGG" , "G" }  
])).

index_of(Item, List) -> index_of(Item, List, 1).

index_of(_, [], _)  -> not_found;
index_of(Item, [Item|_], Index) -> Index;
index_of(Item, [_|Tl], Index) -> index_of(Item, Tl, Index+1).

hamming_distance(A,B)->
  hamming_distance_rec(A,B,0).

hamming_distance_rec([],[],Dist)->
  Dist;
hamming_distance_rec(A,B,Dist)->
  case hd(A) == hd(B) of
    true ->
      hamming_distance_rec(tl(A),tl(B),Dist);
    false ->
      hamming_distance_rec(tl(A),tl(B),Dist+1)
  end.

get_mrna_prot_lookup()->
  ?MrnaProtLookup.

get_protein_weight(Sequence)->
  lists:foldl( fun( A, Acc ) ->
	Acc + dict:fetch(A,?ProteinWeightLookup) end, 0, Sequence).

  
fetch_uniprot(ID)->
  inets:start(),
  {ok, {_Status, _Header, HTML}} = httpc:request(get,{
      string:concat( string:concat( ?UniProtPrefix, ID ) , ?UniProtPostfix ),[]}
    ,[{autoredirect,true}],[]),
  HTML.

fetch_web(Url)->
	inets:start(),
	{ok, {_Status, _Header, HTML}} = httpc:request(Url),
	HTML.

find_all_pos(Input,Char,Count,Out)->
  Lel = length(Input),
  if
    Lel == 0 -> Out;
    Lel == 1 ->
      if
	Input == Char ->
	  [Count|Out];
	true ->
	  Out
      end;
    true->
      if
	hd(Input) == hd(Char) ->
	  find_all_pos(tl(Input),Char,Count+1,[Count|Out]);
	true->
	  find_all_pos(tl(Input),Char,Count+1,Out)
      end
 end.
      

make_reverse_compliment(N)->
  make_compliment(lists:reverse(N)).

 make_compliment(N)->
    K = re:replace(N,"T","Z",[global,{return,list}]),
    J = re:replace(K,"C","Y",[global,{return,list}]),
    B = re:replace(J,"G","C",[global,{return,list}]),
    C = re:replace(B,"A","T",[global,{return,list}]),
    T = re:replace(C,"Z","A",[global,{return,list}]),
    re:replace(T,"Y","G",[global,{return,list}]).

translate_rna_prot(N)->
  translator(N,[]).

translator(N,X)->
  %io:format("N = ~s\n",[N]),
  %io:format("X = ~s\n",[X]),
  T = iolist_size(N),
    if
      N == [] -> X;
      T < 3 -> io:format("T was less than 3",[]), X;
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
N == "ACU" -> "T";
N == "UGG" -> "W";
N == "CGG" -> "R";
N == "AGG" -> "R";
N == "GGG" -> "G";
1 == 1 -> io:format("NOT GOOD N = ~s\n\n",[N]), "NOTGOOD"
end.
  
translate_dna_rna(N)->
  re:replace(N,"T","U",[global,{return,list}]).

make_permutations(N)->
  generate_permutations(N,[],[]).

generate_permutations(N,X,Y) ->
%  io:format("N = ~w\n",[N]),
%  io:format("X = ~w\n",[X]),
%  io:format("Y = ~w\n",[Y]),
   if
     N == [] -> X;
     Y == [] -> generate_permutations(tl(N),lists:umerge(X,[ A || A <- gen_perms(N,[]), 
	     ( 
	       (length(A) > 3) 
	       and (length(A) < 13)
	       and (string:str(X,A) < 1) 
	     ) ]),[]);
     true ->
              generate_permutations(tl(N),
                lists:umerge(X,[ A || A <-  gen_perms(N,[]), string:str(Y,A)>0]),Y)
   end.

 gen_perms(Y,X)->
   if
     Y == [] -> lists:usort(fun(I,J)-> length(I) < length(J) end,X);
     true -> gen_perms(lists:sublist(Y,length(Y)-1),
         X++[Y])
   end.
