load expected_output.mat; 
F=E';
status = odswrite ('list.ods', F,'expected');


