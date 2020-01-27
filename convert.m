%load expected_output; 
%F=E';
%status = odswrite ('list.ods', F,'expected');

%load T10_out; 
%F=E';
%status = odswrite ('list.ods', F,'T10');

%load T15_out; 
%F=E';
%status = odswrite ('list.ods', F,'T15');

%load T25_out; 
%F=E';
%status = odswrite ('list.ods', F,'T25');

%load T50_out; 
%F=E';
%status = odswrite ('list.ods', F,'T50');

load T100_out; 
F=E';
status = odswrite ('list.ods', F,'T100');
