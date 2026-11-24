--  Fires missiles until the launcher counter raises Constraint_Error
with Ada.Text_IO;
use Ada.Text_IO;

procedure Ex05_Missile_Counter is
   type Missile_Count is range 0 .. 8;

   Loaded_Input : constant String := "2";

   Remaining_Missile : Missile_Count :=
     Missile_Count'Value (Loaded_Input);
begin
   Put_Line ("LAUNCHER");

   Put_Line ("Loaded:" & Remaining_Missile'Image);

   Remaining_Missile := Remaining_Missile - 1;
   Put_Line ("Fired, remaining:" & Remaining_Missile'Image);

   Remaining_Missile := Remaining_Missile - 1;
   Put_Line ("Fired, remaining:" & Remaining_Missile'Image);

   Remaining_Missile := Remaining_Missile - 1;
   Put_Line ("Fired, remaining:" & Remaining_Missile'Image);
end Ex05_Missile_Counter;
