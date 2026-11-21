--  Prints the radar heading after each turn, normalized with mod and rem
with Ada.Text_IO;
use Ada.Text_IO;

procedure Ex03_Radar_Heading is
   Full_Circle   : constant         := 360;
   Start_Heading : constant Natural := 10;
   Turn_1        : constant Integer := -30;
   Turn_2        : constant Integer := 400;
   Turn_3        : constant Integer := -725;

   Mod_Column    : constant Positive_Count := 11;
   Rem_Column    : constant Positive_Count := 21;
begin
   Put_Line ("RADAR HEADING");
   Put_Line ("Start heading:" & Start_Heading'Image);

   Put ("Turn");
   Set_Col (Mod_Column);
   Put ("mod");
   Set_Col (Rem_Column);
   Put_Line ("rem");

   --  rem keeps the sign of the dividend: negative headings are invalid
   Put (Turn_1'Image);
   Set_Col (Mod_Column);
   Put (Natural'Image ((Start_Heading + Turn_1) mod Full_Circle));
   Set_Col (Rem_Column);
   Put_Line (Integer'Image ((Start_Heading + Turn_1) rem Full_Circle));

   Put (Turn_2'Image);
   Set_Col (Mod_Column);
   Put (Natural'Image ((Start_Heading + Turn_2) mod Full_Circle));
   Set_Col (Rem_Column);
   Put_Line (Integer'Image ((Start_Heading + Turn_2) rem Full_Circle));

   Put (Turn_3'Image);
   Set_Col (Mod_Column);
   Put (Natural'Image ((Start_Heading + Turn_3) mod Full_Circle));
   Set_Col (Rem_Column);
   Put_Line (Integer'Image ((Start_Heading + Turn_3) rem Full_Circle));

end Ex03_Radar_Heading;
