--  Prints a target status table, aligned with Set_Col
with Ada.Text_IO;
use Ada.Text_IO;

procedure Ex04_Target_Report is
   Status_Column : constant Positive_Count := 15;
begin
   Put_Line ("TARGET REPORT");
   New_Line (3);
   Put ("Name");
   Set_Col (Status_Column);
   Put_Line ("Status");
   Put ("Alpha");
   Set_Col (Status_Column);
   Put_Line ("Tracked");
   Put ("Bravo");
   Set_Col (Status_Column);
   Put_Line ("Lost");
   Put ("Charlie");
   Set_Col (Status_Column);
   Put_Line ("Tracked");
end Ex04_Target_Report;
