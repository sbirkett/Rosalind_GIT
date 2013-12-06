-module(mrna_from_protein).

-export([infer/1]).

-import(helpers,[get_mrna_prot_lookup/0]).

infer(Prot)->
  LookupDict =  helpers:get_mrna_prot_lookup(),
  Vals = dict:fold( fun( Key, Value, Acc) ->
	case dict:is_key( Key, Acc) of
	  true -> dict:append_list(Value, Key, Acc);
	  false -> dict:append(Value, Key, Acc)
	end
    end, dict:new() , LookupDict),
  CountDict = dict:fold( fun( Key, Value, Acc) ->
	dict:append( hd(Key), length(Value), Acc) end, dict:new(), Vals),
  
  Value = lists:foldl( fun( A, Acc ) ->
	if 
	 Acc == 0 -> hd(dict:fetch(A,CountDict));
	 true -> Acc * hd(dict:fetch(A,CountDict))
       end
	end, 0, Prot),
  (Value * 3) rem 1000000.
