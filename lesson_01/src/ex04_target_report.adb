with Ada.Text_IO;
use Ada.Text_IO;

procedure Ex04_Target_Report is
begin
   Put_Line ("TARGET REPORT");
   New_Line (Spacing => 3);
   Put ("Name");
   Set_Col (To => 15);
   Put_Line ("Status");
   Put ("Alpha");
   Set_Col (To => 15);
   Put_Line ("Tracked");
   Put ("Bravo");
   Set_Col (To => 15);
   Put_Line ("Lost");
   Put ("Charlie");
   Set_Col (To => 15);
   Put_Line ("Tracked");
end Ex04_Target_Report;
