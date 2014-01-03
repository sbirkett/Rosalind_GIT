-module(list_helper).

%% ====================================================================
%% API functions
%% ====================================================================
-export(
   [remove_longest_duplication/2,
	swap_elements/3,
	reverse_subsequence/3,
	identify_overlap_with_minimum/3]
	   ).

identify_overlap_with_minimum(A,B,Min)->
	if
		is_list(A) == false ->
			error(badarg);
		is_list(B) == false ->
			error(badarg);
		length(A) > length(B) ->
			remove_longest_duplication_rec_with_min(A,B,Min,length(B));
		true ->
			remove_longest_duplication_rec_with_min(A,B,Min,length(A))
	end.

remove_longest_duplication(A,B)->
  if
    is_list(A) == false -> 
      io:format("A NOT A LIST !!! \n",[]),
      io:format("A = ~w\n",[A]),
      io:format("B = ~w\n",[B]),
      error(badarg);
    is_list(B) == false ->
      io:format("B NOT A LIST !!!\n",[]),
      io:format("A = ~w\n",[A]),
      io:format("B = ~w\n",[B]),
      error(badarg);
    length(A) > length(B) -> 
      Pos = string:str(A,B),
      if
	Pos == 0 ->
      	    Overlap = remove_longest_duplication_rec(A,B,length(B)),
            {Overlap,lists:sublist(A,length(A)-Overlap) ++ B};
	  true ->
	    {length(B),A}
       end;
    true ->
      Pos = string:str(B,A),
      if
	Pos == 0 ->
      	    Overlap = remove_longest_duplication_rec(A,B,length(A)),
            {Overlap,lists:sublist(A,length(A)-Overlap) ++ B};
	true -> 
	  {length(B),A}
      end
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

remove_longest_duplication_rec_with_min(A,B,Min,FrameSize)->
	
   if 
	   Min > FrameSize -> 0;
	   true ->
	
           First = lists:nthtail(length(A)-FrameSize,A),
           Second = lists:sublist(B,FrameSize),
           Dup = confirm_duplication(First++Second),

           if
               Dup -> FrameSize;
               FrameSize == 0 -> 0;
               true -> remove_longest_duplication_rec_with_min(A,B,Min,FrameSize-1)
           end
  end.

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
