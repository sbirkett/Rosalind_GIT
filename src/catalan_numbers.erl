-module(catalan_numbers.erl).

-include_lib("../rosalind_records.hrl").

-import(fasta_reader,[read/1]).

export([solve/1]).

solve(File)->
  compile:file("../fasta_reader.erl"),
  Fasta = hd(fasta_reader:read(File)),
  Seq = Fasta#fasta.sequence.


% Make base start
% All Graphs made from connecting edges that connect over an
% outer span of 2*(k)
make_base_set(Nodes)->
  1.

% Construct all the possible sub graphs
make_valid_sub_graphs(Graph)->
  1.

% Check outside edges scenario
% Two possible.
outside_check(Nodes)->
outside_check(Nodes)->
  1.

% Check if graph complete
check_complete(Graph)->
  1.