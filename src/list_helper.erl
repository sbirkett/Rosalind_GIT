-module(list_helper).

%% ====================================================================
%% API functions
%% ====================================================================
-export([remove_longest_duplication/2,swap_elements/3,reverse_subsequence/3]).

remove_longest_duplication(A,B)->
  if
    length(A) > length(B) -> remove_longest_duplication_rec(A,B,length(B));
    true -> 
      Overlap = remove_longest_duplication_rec(A,B,length(A)),
      lists:sublist(A,length(A)-Overlap) ++ B
  end.

swap_elements(List,X,Y)->
  swap_elements_rec(List,X,Y,[],1).

reverse_subsequence(List,X,Y)->
  First = lists:sublist(List,X-1),
  {Garb,Last} = lists:split(Y,List),
  {OtherBag,SubSec} = lists:split(X-1,Garb),
  First ++ lists:reverse(SubSec) ++ Last.

%% ====================================================================
%% Internal functions
%% ====================================================================

%Performed Greedy
remove_longest_duplication_rec(A,B,FrameSize)->

   First = lists:nthtail(length(A)-FrameSize,A),
   Second = lists:sublist(B,FrameSize),
   Dup = confirm_duplication(First++Second),

   if
       Dup -> FrameSize;
       FrameSize == 0 -> 0;
       true -> remove_longest_duplication_rec(A,B,FrameSize-1)
   end.

confirm_duplication(Segment)->
  if
    length(Segment) rem 2 /= 0 ->
      length(Segment) == length( [ T || T <- Segment, T == hd(Segment) ] );
    true -> 
      lists:sublist(Segment,round(length(Segment)/2)) == lists:sublist(Segment,round((length(Segment)/2)+1),length(Segment))
  end.

swap_elements_rec(List,X,Y,Out,CurrIndex)->
  if
	  (CurrIndex -1 ) == length(List) -> Out;
	  CurrIndex == X -> swap_elements_rec(List,X,Y,Out ++ [lists:nth(Y,List)],CurrIndex+1);
	  CurrIndex == Y -> swap_elements_rec(List,X,Y,Out ++ [lists:nth(X,List)],CurrIndex+1);
	  true ->
		  swap_elements_rec(List,X,Y,Out ++ [lists:nth(CurrIndex,List)],CurrIndex+1)
  end.
