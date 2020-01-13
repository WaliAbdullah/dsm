[A, rows, cols, entries] = mmread("file.mtx");
A;
B = logical(A);
C=full(B);