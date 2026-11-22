--  Prints the radar track states and their enumeration attributes
with Ada.Text_IO;
use Ada.Text_IO;

procedure Ex02_Track_Status is
   type Track_Status is (Tentative, Confirmed, Coasting, Lost);
   subtype Active_Status is Track_Status range Tentative .. Coasting;

   Last_Rank        : constant Natural  :=
     Track_Status'Pos (Track_Status'Last);
   Number_Of_Values : constant Positive := Last_Rank + 1;

   Reference_Status : constant Track_Status := Confirmed;

   Operator_Input   : constant String   := "coasting";
begin
   Put_Line ("TRACK STATUS");

   Put_Line ("Values: " & Track_Status'First'Image
     & " .. " & Track_Status'Last'Image);

   Put_Line ("Count:" & Number_Of_Values'Image);

   Put_Line ("Active: " & Active_Status'First'Image
     & " .. " & Active_Status'Last'Image);

   Put_Line ("After " & Reference_Status'Image
     & " comes " & Track_Status'Succ (Reference_Status)'Image);

   Put_Line ("Rank of " & Track_Status'Last'Image & ":"
     & Last_Rank'Image);

   Put_Line ("Operator input """ & Operator_Input & """ -> "
     & Track_Status'Value (Operator_Input)'Image);
end Ex02_Track_Status;
