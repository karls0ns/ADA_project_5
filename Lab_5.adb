with Text_IO;
use  Text_IO;

procedure Lab_5 is

   task MaxElementInRow is
      entry TotalRequests(N : in integer);
      entry Row(R : in integer);
   end MaxElementInRow;

   task ListOfRows is
      entry Result(Max : in Integer);
   end ListOfRows;

   task body MaxElementInRow is
      N : constant Integer := 6;
      M : constant Integer := 5;
      type Matrix is array(1..N, 1..M) of Integer;
      Matr : Matrix := (
         (0, 0, 10, 0, 0),
         (1, 20, 1, 1, 1),
         (1, 2, 30, 2, 1),
         (40, 1, 2, 3, 1),
         (1, 50, 4, 1, 2),
         (1, 2, 60, 5, 4)
      );

      RNum    : Integer;
      Max     : Integer;
      Total   : Integer;
      Counter : Integer := 0;
      CountB : Integer;
   begin
      Put_Line("");     -- fictive statement
      delay 0.1;
      accept TotalRequests(N: in Integer) do
         Total := N;
      end TotalRequests;

      CountB:=0;
      while (Counter < Total) loop
        -- delay 0.2;
         select
            accept Row(R : in integer) do
               RNum := R;
            end Row;

         Put_line("");
         Put_Line("Task 'MaxElementInRow': waiting in 'Row' = " & Integer'Image(CountB));
         Max := Matr(RNum, Matr'First(2));
         for j in Matr'Range(2) loop
            if (Matr(RNum, j) > Max) then
               Max := Matr(RNum, j);
            end if;
         end loop;

         Counter := Counter + 1;
         ListOfRows.Result(Max);

        or
            delay 0.02;
            Put("#");
            CountB:=CountB+1;
         end select;

      end loop;
   end MaxElementInRow;

   task body ListOfRows is
      N : constant Integer := 7;
      type Vector is array(Integer range<>) of Integer;
      V : Vector(1..N) := (2, 3, 6, 1, 5, 1, 4);
      i : Integer := V'First;
      MaxElem : Integer;
      CountA : Integer :=0;
   begin
      loop
         select
            MaxElementInRow.TotalRequests(V'Length);
            exit;
         else
            delay 0.001;
            Put("*");
            CountA:= CountA+1;
         end select;
      end loop;
         Put_Line("");
         Put_Line("Task 'ListofRows': TOTAL waiting of entry 'TotalRequests' = " & Integer'Image(CountA));
      while (i <= V'Length) loop
         delay 0.3;
         MaxElementInRow.Row(V(I));

         accept Result(Max: in Integer) do
            MaxElem := Max;
         end Result;
         Put_Line("Row:" & Integer'Image(V(i)) &
            ". Maximal element:" & Integer'Image(MaxElem) & ".");
         i := i+1;
      end loop;
   end ListOfRows;

begin
   null;
end Lab_5;