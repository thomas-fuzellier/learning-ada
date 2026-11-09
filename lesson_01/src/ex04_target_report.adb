--  Learning how to search for procedures for lesson 01
with Ada.Text_IO;
use Ada.Text_IO;

procedure Ex04_Target_Report is
begin
   Put_Line ("TARGET REPORT");
   New_Line (3);
   Put ("Name");
   Set_Col (15);
   Put_Line ("Status");
   Put ("Alpha");
   Set_Col (15);
   Put_Line ("Tracked");
   Put ("Bravo");
   Set_Col (15);
   Put_Line ("Lost");
   Put ("Charlie");
   Set_Col (15);
   Put_Line ("Tracked");
end Ex04_Target_Report;
