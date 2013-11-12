-module(mendel_first).
-export([start/1]).


	
start(N) ->
  
  T = string:tokens(N," "),
  
  {A,[]} = string:to_integer(lists:nth(1,T)),
  {B,[]} = string:to_integer(lists:nth(2,T)),
  {C,[]} = string:to_integer(lists:nth(3,T)),
  
  I = A / (A + B + C), %I are done
  J = B / (A + B + C),
  K = C / (A + B + C),

  JA = J * (A / (A + B - 1 + C)),
  JB = J * ((B-1) / (A + B-1 + C)),
  JC = J * (C / (A + B-1 + C)),

  KA = K * (A / (A + B + C -1)),
  KB = K * (B / (A + B + C -1)),
  
  I + JA + JB * 0.75 + JC * 0.5 + KA + KB * 0.5.
